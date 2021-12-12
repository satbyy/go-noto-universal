#!/bin/bash -e

[[ -z "$VIRTUAL_ENV" ]] && echo "Refusing to run outside of venv. See README.md." && exit 1

main() {
    python3 -m pip install fonttools

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
        echo "Generating font $font. Current time: $(date).\n"
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
            wget https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/NotoSerifTibetan/NotoSerifTibetan-Regular.ttf
        fi
        echo "Creating a smaller subset of Tibetan glyphs..."
        "$VIRTUAL_ENV"/bin/pyftsubset NotoSerifTibetan-Regular.ttf --output-file=NotoSerifTibetanSubset-Regular.ttf \
                  --unicodes=U+0F00-0F8C,U+0F90,U+0F92,U+0F94,U+0F99,U+0F9F,U+0FA4,U+0FA9,U+0FAD,U+0FB1-0FB3,U+0FBA-0FDA
    fi
    cd "$OLDPWD"
}

# Rename "Noto Sans" to "Go Noto Whatever"
edit_font_info() {
    local fontname="$1"
    local without_spaces="${fontname%%.*}"
    local with_spaces=$(echo "$without_spaces" | sed -E 's/([a-z])([A-Z])/\1 \2/g')
    local xml_file="$without_spaces".ttx
    local xml_file_bak="$xml_file".bak
    echo "Editing font metadata for $fontname..."
    "$VIRTUAL_ENV"/bin/ttx -o "$xml_file" "$fontname" 2> /dev/null
    [[ $? -ne 0 ]] && echo "ERROR: Could not dump $fontname to xml." && return 1
    sed -e "s/Noto Sans/$with_spaces/g" -e "s/NotoSans/$without_spaces/g" "$xml_file" > "$xml_file_bak"
    mv "$xml_file_bak" "$xml_file"
    "$VIRTUAL_ENV"/bin/ttx -o "$fontname" "$xml_file" 2> /dev/null
    [[ $? -ne 0 ]] && echo "ERROR: Could not dump xml to $fontname." && return 2
    rm -f "$xml_file"
}

# Unicode IICore 2003 is a small subsetof CJK (~10k codepoints).
# Recently is has been superceded by UnihanCore2020.
create_cjk_subset() {
    local fontname=GoNotoCJKCore2003.otf

    cd cached_fonts/
    [[ ! -e Unihan.zip ]] && wget https://www.unicode.org/Public/UCD/latest/ucd/Unihan.zip
    python3 -m zipfile -e Unihan.zip .
    grep kIICore Unihan_IRGSources.txt | cut -f1 > unicode_points.txt
    if [[ ! -e NotoSansCJKsc-Regular.otf ]]; then
        wget https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/NotoSansCJKsc-Regular.otf
    fi
    cd "$OLDPWD"
    echo "Generating font $fontname."
    "$VIRTUAL_ENV"/bin/pyftsubset cached_fonts/NotoSansCJKsc-Regular.otf \
                  --unicodes-file=cached_fonts/unicode_points.txt \
                  --output-file="$fontname"
    edit_font_info "$fontname"
}

# execution starts here
main
