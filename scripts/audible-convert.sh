#!/usr/bin/env bash

if [ -z "$(which ffmpeg)" ] || [ -z "$(which audible)" ] || [ -z "$(which jq)" ]; then
    echo "Error: Needs ffmpeg, audible-cli and jq installed"
fi

if [[ -z "$1" && -z "$2" ]]; then
    echo "Usage: ./convert.sh <ASIN> <outFile> [--aacx]"
    audible library list
    exit 1
fi

ext="$3"
set -euo pipefail

asin="$1"

dir=$(mktemp -d)
echo "$dir"

if [ "$ext" == "--aacx" ]; then
  aax="--aaxc"
else
  aax="--aax-fallback"
fi

audible download -a "$asin" "$aax" --cover --cover-size 1215 --chapter -o "$dir"

info=$(audible api -p response_groups="media,contributors,series,category_ladders" /1.0/library/"$asin" | jq '.item')

chapter_txt="$dir/chapters.txt"
series_info=$(echo "$info" | jq '.series | if (length > 0) then sort_by(.sequence | tonumber) | .[-1] else "" end')

for f in "$dir"/*.voucher; do
  echo "Preparing to decrypt aacx file"
  key=$(jq -r '.content_license.license_response.key' < "$f")
  iv=$(jq -r '.content_license.license_response.iv' < "$f")
  decrypt="-audible_key $key -audible_iv $iv"
done
if [ -z "$key" ]; then
  echo "Preparing to decrypt aac file"
  decrypt="-activation_bytes $(audible activation-bytes)"
fi
echo "$decrypt"

# shellcheck disable=2086
copyright=$(ffprobe $decrypt "$dir"/*.aax* 2>&1 | grep copyright | sed 's/^.*: //')

# Write book metadata
echo ";FFMETADATA1
title=$(echo "$info" | jq -r '.title')
artist=$(echo "$info" | jq -r '.authors | [.[].name] | join(", ")')
composer=$(echo "$info" | jq -r '.narrators | [.[].name] | join(", ")')
year=$(echo "$info" | jq -r '.release_date | sub("-[0-9][0-9]-[0-9][0-9]"; "")')
copyright=$copyright
language=$(echo "$info" | jq -r '.language')
description=$(echo "$info" | jq -r '.merchandising_summary | sub("</?[a-z]+>"; ""; "g")')
asin=$asin
" > "$chapter_txt"

if [ "$series_info" != '""' ]; then
    echo "series=$(echo "$series_info" | jq -r '.title')
series-part=$(echo "$series_info" | jq -r '.sequence')
" >> "$chapter_txt"
fi

# Write chapter timestamps to txt
jq -r '.content_metadata.chapter_info.chapters
    | reduce .[] as $c ([]; if $c.chapters? then .+[$c | del(.chapters)]+[$c.chapters] else .+[$c] end)
    | flatten
    | .[] |
"[CHAPTER]
TIMEBASE=1/1000
START=\((.start_offset_ms))
END=\((.start_offset_ms + .length_ms))
title=\((.title))
"' < "$dir"/*.json >> "$chapter_txt"

# We reencode the file because some players have problems with the way audible encodes their files
# the ffmpeg reencode "cleans up" the file
# shellcheck disable=2086
ffmpeg $decrypt \
    -i "$dir"/*.aax* -i "$dir"/*.jpg -i "$chapter_txt" \
    -map 0:a -map 1:v -map_metadata 2 -map_chapters 2 -c:v copy \
    -c:a aac \
    -id3v2_version 3 \
    -disposition:v attached_pic -movflags +faststart -movflags +use_metadata_tags \
    -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" \
    -metadata:s:a language="$(echo "$info" | jq -r '.language.[0:3]')" \
    "$2"

rm -r "$dir"
