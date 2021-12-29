#!/usr/bin/env bash
set -e

[[ -z "$VIRTUAL_ENV" ]] && echo "Refusing to run outside of venv. See README.md." && exit 1

python3 -m pip install 'fonttools >= 4.28.5'

# import functions and globals
source helper.sh
source categories.sh

# --- execution starts here ---
mkdir -p cache/

create_tibetan_subset
drop_vertical_tables NotoSerifDogra-Regular.ttf
drop_vertical_tables NotoSansNandinagari-Regular.ttf
drop_vertical_tables NotoSansMongolian-Regular.ttf
drop_vertical_tables NotoSansNushu-Regular.ttf
drop_vertical_tables NotoSerifTangut-Regular.ttf

declare -a fonts=(
    GoNotoAfricaMiddleEast
    GoNotoSouthAsia
    GoNotoAsiaHistorical
    GoNotoSouthEastAsia
    GoNotoEastAsia
    GoNotoEuropeAmericas
)

for font in "${fonts[@]}"; do
    if [[ -e "$font.ttf" ]]; then
        echo "Not overwriting existing font $font."
        continue
    fi
    declare -n source_fonts="$font" # nameref to array in categories.sh
    echo "Generating font $font. Current time: $(date)."
    go_build "$font.ttf" "${source_fonts[@]}"
done

create_cjk_unihan_core
