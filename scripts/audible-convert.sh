#!/usr/bin/env bash

if [ -z "$(which ffmpeg)" ] || [ -z "$(which audible)" ] || [ -z "$(which jq)" ]; then
    echo "Error: Needs ffmpeg, audible-cli and jq installed"
fi

if [[ -z "$1" && -z "$2" ]]; then
    echo "Usage: ./convert.sh <ASIN> <outFile>"
    audible library list
    exit 1
fi

set -euo pipefail

asin="$1"

dir=$(mktemp -d)
echo "$dir"

audible download -a "$asin" --aax-fallback --cover --cover-size 1215 --chapter -o "$dir"

info=$(audible api -p response_groups="media,contributors,series,category_ladders" /1.0/library/"$asin" | jq '.item')

chapter_txt="$dir/chapters.txt"
series_info=$(echo "$info" | jq '.series | if (length > 0) then sort_by(.sequence | tonumber) | .[-1] else "" end')
bytes=$(audible activation-bytes)
copyright=$(ffprobe -activation_bytes "$bytes" "$dir"/*.aax* 2>&1 | grep copyright | sed 's/^.*: //')

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

ffmpeg -activation_bytes "$bytes" \
    -i "$dir"/*.aax* -i "$dir"/*.jpg -i "$chapter_txt" \
    -map 0:a:0 -map 1:v:0 -map_metadata 2 -map_chapters 2 -c copy \
    -disposition:v attached_pic -movflags +faststart -movflags +use_metadata_tags \
    -metadata:s:v title="Album cover" -metadata:s:v comment="Cover (front)" \
    -metadata:s:a language="$(echo "$info" | jq -r '.language.[0:3]')" \
    "$2"
