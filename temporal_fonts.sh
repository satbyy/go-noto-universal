#!/usr/bin/env bash
set -e

[[ -z "$VIRTUAL_ENV" ]] && echo "Refusing to run outside of venv. See README.md." && exit 100

python3 -m pip install 'fonttools >= 4.28.5'

# import functions and globals
source helper.sh
source categories.sh

go_build() {
    local output="$1"       # name of generated font
    local input=("${@:2}")  # list of fonts to merge

    if [[ -e "$output" ]]; then
        echo "Not overwriting existing font $output."
        return
    fi

    cd cache/
    for font in "${input[@]}"; do
        if [[ ! -e "$font" ]]; then
            noto_dir="${font%-*}"
            download_url "https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/$noto_dir/$font"
        fi
    done

    echo "Merging ${#input[@]} fonts..."
    time "$VIRTUAL_ENV"/bin/pyftmerge --drop-tables+=vhea,vmtx \
         --verbose --output-file=../"$output" "${input[@]}"

    cd "$OLDPWD"

    edit_font_info "$output"
}

# --- execution starts here ---
mkdir -p cache/

create_cjk_subset
create_japanese_kana_subset
create_korean_hangul_subset
create_tibetan_subset
drop_vertical_tables NotoSansMongolian-Regular.ttf
drop_vertical_tables NotoSansNushu-Regular.ttf
echo "Generating GoNotoCurrent.ttf..."
go_build GoNotoCurrent.ttf "${current[@]}"

echo "Generating GoNotoAncient.ttf..."
drop_vertical_tables NotoSerifDogra-Regular.ttf
drop_vertical_tables NotoSansNandinagari-Regular.ttf
drop_vertical_tables NotoSerifTangut-Regular.ttf
go_build GoNotoAncient.ttf "${ancient[@]}"
