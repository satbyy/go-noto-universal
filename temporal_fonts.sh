#!/usr/bin/env bash
set -e

[[ -z "$VIRTUAL_ENV" ]] && echo "Refusing to run outside of venv. See README.md." && exit 100

python3 -m pip install 'fonttools >= 4.41.1'

# import functions and globals
source url.sh
source helper.sh
source categories.sh

# --- execution starts here ---
mkdir -p cache/

# GoNotoCurrent.ttf
create_cjk_subset
create_duployan_subset
create_japanese_kana_subset
create_korean_hangul_subset
create_math_subset
create_tibetan_subset
drop_vertical_tables NotoSansMongolian-Regular.ttf
drop_vertical_tables NotoSansNushu-Regular.ttf
drop_vertical_tables NotoTraditionalNushu-Bold.ttf
echo "Generating GoNotoCurrent.ttf. Current time: $(date)."
go_build GoNotoCurrent.ttf "${GoNotoCurrent[@]}"
go_build GoNotoCurrent-Bold.ttf "${GoNotoCurrentBold[@]}"

# GoNotoAncient.ttf
drop_vertical_tables NotoSerifDogra-Regular.ttf
drop_vertical_tables NotoSansNandinagari-Regular.ttf
drop_vertical_tables NotoSerifTangut-Regular.ttf
echo "Generating GoNotoAncient.ttf. Current time: $(date)."
go_build GoNotoAncient.ttf "${GoNotoAncient[@]}"

# GoNotoCurrentSerif.ttf
echo "Generating GoNotoCurrentSerif.ttf. Current time: $(date)."
go_build GoNotoCurrentSerif.ttf "${GoNotoCurrentSerif[@]}"

# GoNotoAncientSerif.ttf
echo "Generating GoNotoAncientSerif.ttf. Current time: $(date)."
go_build GoNotoAncientSerif.ttf "${GoNotoAncientSerif[@]}"
