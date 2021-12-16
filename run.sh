#!/bin/bash -e

[[ -z "$VIRTUAL_ENV" ]] && echo "Refusing to run outside of venv. See README.md." && exit 1

main() {
    python3 -m pip install 'fonttools >= 4.28.4'

    if [[ ! -d nototools ]]; then
        git clone --depth 1 https://github.com/googlefonts/nototools
    else
        echo "Re-using existing clone of nototools."
    fi

    # Patch merge_fonts.py to be callable by external script
    cd nototools/
    if ! git apply --reverse --check ../merge_fonts.patch 2> /dev/null; then
        echo "applying patch."
        git apply ../merge_fonts.patch
    else
        echo "patch already applied."
    fi
    cd "$OLDPWD"

    subset_tibetan
    drop_vertical_tables NotoSerifDogra-Regular.ttf
    drop_vertical_tables NotoSansNandinagari-Regular.ttf

    declare -a fonts=(
        GoNotoAfricaMiddleEast.ttf
        GoNotoSouthAsia.ttf
        GoNotoAsiaHistorical.ttf
        GoNotoSouthEastAsia.ttf
        GoNotoEastAsia.ttf
        GoNotoEuropeAmericas.ttf
    )

    for font in "${fonts[@]}"; do
        if [[ -e "$font" ]]; then
            echo "Not overwriting existing font $font."
            continue
        fi
        echo "Generating font $font. Current time: $(date)."
        mkdir -p cached_fonts
        time PYTHONPATH="nototools/nototools" python3 generate.py -o "$font" -d cached_fonts
        edit_font_info "$font"
    done

    create_cjk_subset
}

# create tibetan subset so that GSUB is not overflow'ed.
subset_tibetan() {
    mkdir -p cached_fonts/ && cd cached_fonts/
    if [[ ! -e NotoSerifTibetanSubset-Regular.ttf ]]; then
        if [[ ! -e NotoSerifTibetan-Regular.ttf ]]; then
            wget -nv https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/NotoSerifTibetan/NotoSerifTibetan-Regular.ttf
        fi
        echo "Creating a smaller subset of Tibetan glyphs..."
        "$VIRTUAL_ENV"/bin/pyftsubset NotoSerifTibetan-Regular.ttf --output-file=NotoSerifTibetanSubset-Regular.ttf \
                --glyph-names --no-layout-closure --glyphs="$(
                    "$VIRTUAL_ENV"/bin/ttx -o - -q -t GlyphOrder NotoSerifTibetan-Regular.ttf \
                    | grep '<GlyphID ' | cut -f4 -d'"' | grep -Ev '^uni0F([45].|6[013-9ABC])0F(9.|A[^D]|B[^12])'
                )"
    fi
    cd "$OLDPWD"
}

# cannot merge with 'vmtx' and 'vhea' tables.
drop_vertical_tables() {
    local fontname="$1"
    local output_font="${fontname/-/Subset-}"
    local dirname="${fontname/-*/}"

    mkdir -p cached_fonts/ && cd cached_fonts/

    if [[ ! -e "$fontname" && ! -e "$output_font" ]]; then
        wget -nv -O "$fontname" "https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/$dirname/$fontname"
        echo "Removing vertical tables from $fontname"
        "$VIRTUAL_ENV"/bin/pyftsubset "$fontname" \
                      --output-file="$output_font" \
                      --glyphs='*' \
                      --drop-tables+=vhea,vmtx
    fi

    cd "$OLDPWD"
}

# Rename "Noto Sans" to "Go Noto Whatever"
edit_font_info() {
    local fontname="$1"
    local without_spaces="${fontname%%.*}"
    local with_spaces=$(echo "$without_spaces" | sed -E 's/([a-z])([A-Z])/\1 \2/g')

    python3 ./rename_font.py "$fontname" "$with_spaces" "$without_spaces"
}

# Unihan IICore 2005 is a small subset of CJK (~10k codepoints).
# Recently it has been superseded by UnihanCore2020, which is double in size.
create_cjk_subset() {
    local input_font=NotoSansCJKsc-Regular.otf
    local output_font=GoNotoCJKCore2005.otf
    local subset_codepoints=unihan_iicore.txt

    if [[ -e "$output_font" ]]; then
        echo "Not overwriting existing font $output_font."
        return
    fi

    cd cached_fonts/
    [[ ! -e Unihan.zip ]] && wget -nv https://www.unicode.org/Public/UCD/latest/ucd/Unihan.zip
    python3 -m zipfile -e Unihan.zip .
    grep kIICore Unihan_IRGSources.txt | cut -f1 > "$subset_codepoints"
    python3 ../get_codepoints.py NotoSans-Regular.ttf >> "$subset_codepoints"
    if [[ ! -e "$input_font" ]]; then
        wget -nv https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/"$input_font"
    fi
    cd "$OLDPWD"

    echo "Generating font $output_font. Current time: $(date)."
    "$VIRTUAL_ENV"/bin/pyftsubset cached_fonts/"$input_font" \
                  --unicodes-file=cached_fonts/"$subset_codepoints" \
                  --output-file="$output_font"

    python3 ./rename_font.py "$output_font" \
                             "Go Noto CJK Core 2005" \
                             "${output_font%%.*}"
}

# execution starts here
main
