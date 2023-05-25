#!/usr/bin/env bash -eu

download_url() {
    local max_retry=20
    local name=''
    name=$(basename "$1")

    # Do not download if file already exists
    if [[ ! -e "$name" ]]; then
        for try in $(seq 1 "$max_retry"); do
            wget -nv -O "$name" "$1"
            if [[ $? -eq 0 ]]; then
                break
            else
                echo "Attempt $try/$max_retry to download $1"
                sleep 10
            fi
        done
    fi
}

# Rename font metadata
edit_font_info() {
    local fontname="$1"
    local without_spaces="${fontname%%.*}"
    local with_spaces=''

    with_spaces=$(echo "$without_spaces" | sed -E 's/([a-z])([A-Z])/\1 \2/g')

    python3 ./rename_font.py "$fontname" "$with_spaces" "$without_spaces"
}

# Font statistics are dumped to stdout in tsv format (tab separated
# value), redirect stdout to file when called interactively
collect_font_statistics() {
    cat << 'eof' > stats.py
import sys
from fontTools import ttLib;
f = ttLib.TTFont(sys.argv[1]);
try:
    print('%d\t%d' % (f['maxp'].numGlyphs, f['GSUB'].table.LookupList.LookupCount));
except:
    # GSUB doesn't exist
    print('%d\t%d' % (f['maxp'].numGlyphs, 0));
f.close()
eof
    printf "Font\tCodepoints\tGlyphs\tGSUB_Lookup_Count\n"
    for font in *.ttf cache/*.ttf; do
        printf "$font\t";
        python3 ./get_codepoints.py "$font" | sort | uniq | wc -l | tr '\n' '\t';
        python3 ./stats.py "$font";
    done
    rm -f stats.py
}

# cannot merge with 'vmtx' and 'vhea' tables.
drop_vertical_tables() {
    local fontname="$1"
    local output_font="${fontname/-/Subset-}"
    local dirname="${fontname/-*/}"

    cd cache/

    if [[ ! -e "$output_font" ]]; then
        download_url "${font_urls[$fontname]}"
        echo "Removing vertical tables from $fontname"
        "$VIRTUAL_ENV"/bin/pyftsubset --recommended-glyphs --passthrough-tables \
                      --glyphs='*' --unicodes='*' --glyph-names --layout-features='*' \
                      --drop-tables+=vhea,vmtx "$fontname" --output-file="$output_font"
    fi

    cd "$OLDPWD"
}

# create Duployan subset so that GSUB is not overflow'ed.
create_duployan_subset() {
    local input_font=NotoSansDuployan-Regular.ttf
    local output_font="${input_font/-/Subset-}"
    local include_regex='^[^_]\|^_u1BC9D\.dtls$'
    local exclude_regex='^u1BC7[0-7]\..*\.'

    cd cache/

    if [[ ! -e "$output_font" ]]; then
        download_url "${font_urls[$input_font]}"

        echo "Creating a smaller subset of Duployan glyphs..."
        local glyphs_file=duployan_glyphs.txt
        "$VIRTUAL_ENV"/bin/ttx -o - -q -t GlyphOrder "$input_font" \
                      | grep '<GlyphID ' | cut -f4 -d'"' \
                      | grep "$include_regex" \
                      | grep -v  "$exclude_regex" \
                      > "$glyphs_file"
        "$VIRTUAL_ENV"/bin/pyftsubset --passthrough-tables --notdef-outline \
                      --layout-features+=subs,sups --layout-features-=curs,rclt \
                      --glyph-names --no-layout-closure \
                      --glyphs-file="$glyphs_file" "$input_font" --output-file="$output_font"
    fi

    python3 ../rename_font.py "$output_font" "Noto Duployan Subset" "NotoDuployanSubset"

    cd "$OLDPWD"
}

# create tibetan subset so that GSUB is not overflow'ed.
create_tibetan_subset() {
    local input_font=NotoSerifTibetan-Regular.ttf
    local output_font="${input_font/-/Subset-}"
    local glyphs=0
    local exclude_regex='uni0F([45].|6[^2])0F(9.|A[^D]|B[^12])|uni[[:xdigit:]]{8,12}\.[23]|uni0F(4[3D]|5[27C]|69).|0F..0F74'

    cd cache/

    if [[ ! -e "$output_font" ]]; then
        download_url "${font_urls[$input_font]}"

        echo "Creating a smaller subset of Tibetan glyphs..."
        glyphs=$("$VIRTUAL_ENV"/bin/ttx -o - -q -t GlyphOrder "$input_font" \
                     | grep '<GlyphID ' | cut -f4 -d'"' \
                     | grep -Ev  "$exclude_regex" \
                )
        "$VIRTUAL_ENV"/bin/pyftsubset --recommended-glyphs --passthrough-tables \
                      --layout-features='*' --glyph-names --no-layout-closure \
                      --glyphs="${glyphs}" "$input_font" --output-file="$output_font"
    fi

    python3 ../rename_font.py "$output_font" "Noto Tibetan Subset" "NotoTibetanSubset"

    cd "$OLDPWD"
}

# create Math subset to remove MATH table and MATH-specific glyphs
create_math_subset() {
    local input_font=NotoSansMath-Regular.ttf
    local output_font="${input_font/-/Subset-}"
    local exclude_regex='\.[btx]$\|\.dotless$\|\.s[0-9]\+$\|\.ssty[12]$'

    cd cache/

    if [[ ! -e "$output_font" ]]; then
        download_url "${font_urls[$input_font]}"

        echo "Creating a smaller subset of Math glyphs..."
        local glyphs_file=math_glyphs.txt
        "$VIRTUAL_ENV"/bin/ttx -o - -q -t GlyphOrder "$input_font" \
                      | grep '<GlyphID ' | cut -f4 -d'"' \
                      | grep -v "$exclude_regex" \
                      > "$glyphs_file"
        "$VIRTUAL_ENV"/bin/pyftsubset --passthrough-tables --notdef-outline \
                      --drop-tables+=MATH \
                      --layout-features=aalt,abvm,ccmp,fwid,kern,mark,mkmk,rtla,ss01 \
                      --glyph-names --no-layout-closure \
                      --glyphs-file="$glyphs_file" "$input_font" --output-file="$output_font"
    fi

    python3 ../rename_font.py "$output_font" "Noto Math Subset" "NotoMathSubset"

    cd "$OLDPWD"
}

# Unihan IICore 2005 is a small subset of CJK (~10k codepoints).
# Recently it has been superseded by UnihanCore2020, which is double in size.
create_cjk_unihan_core() {
    local input_font=NotoSansCJKsc-Regular.otf
    local subset_otf=GoNotoSansCJKscSubset-Regular.otf
    local subset_ttf="${subset_otf/otf/ttf}"
    local output_font=GoNotoCJKCore.ttf
    local subset_codepoints=unihan_core_2020.txt
    local codepoints=""

    codepoints+="U+2500-257F,"   # Box drawing
    codepoints+="U+2E80-2EFF,"   # CJK radicals supplement
    codepoints+="U+2F00-2FD5,"   # Kangxi radicals
    codepoints+="U+2FF0-2FFF,"   # Ideographic description characters
    codepoints+="U+3000-303F,"   # CJK symbols and punctuation
    codepoints+="U+3100-312F,"   # Bopomofo
    codepoints+="U+3190-319F,"   # Kanbun
    codepoints+="U+31A0-31BF,"   # Bopomofo extended
    codepoints+="U+31C0-31EF,"   # CJK strokes
    codepoints+="U+FE30-FE4F,"   # CJK compatibility forms, used with vertical writing
    codepoints+="U+1100-11FF,"   # Hangul jamo
    codepoints+="U+3130-318F,"   # Hangul compatibility jamo
    codepoints+="U+3040-309F,"   # Hiragana
    codepoints+="U+30A0-30FF,"   # Katakana
    codepoints+="U+31F0-31FF,"   # Katakana phonetic extensions
    codepoints+="U+3200-32FF,"   # Enclosed CJK letters and months
    codepoints+="U+3300-33FF,"   # CJK Compatibility
    codepoints+="U+A960-A97F,"   # Hangul jamo extended-A
    codepoints+="U+AC00-D7AF,"   # Hangul syllables
    codepoints+="U+D7B0-D7FF,"   # Hangul jamo extended-B
    codepoints+="U+F900-FAFF,"   # CJK compatibility ideographs
    codepoints+="U+FF00-FFEF,"   # Halfwidth and fullwidth forms
    codepoints+="U+1F200-1F2FF," # Enclosed ideographic supplement

    if [[ -e "$output_font" ]]; then
        echo "Not overwriting existing font $output_font."
        return
    fi

    cd cache/

    download_url "https://www.unicode.org/Public/UCD/latest/ucd/Unihan.zip"
    python3 -m zipfile -e Unihan.zip .
    grep kIICore Unihan_IRGSources.txt | cut -f1 > "$subset_codepoints"
    grep kUnihanCore2020 Unihan_DictionaryLikeData.txt | cut -f1 >> "$subset_codepoints"

    # Choose U+4e00 to U+6000 to avoid cmap format 4 subtable overflow
    # (reduce number of segments)
    for code in $(seq 0x4e00 0x6000); do
        printf "U+%X\n" "$code"
    done >> "$subset_codepoints"

    sort --unique --output="$subset_codepoints" "$subset_codepoints"
    download_url "https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/$input_font"

    echo "Generating font $subset_otf. Current time: $(date)."
    "$VIRTUAL_ENV"/bin/pyftsubset "$input_font" \
                  --unicodes-file="$subset_codepoints" --unicodes="$codepoints" \
                  --recommended-glyphs --passthrough-tables --glyph-names \
                  --layout-features='*' --output-file="$subset_otf"

    # convert otf to ttf
    echo "Generating font $subset_ttf. Current time: $(date)."
    download_url https://github.com/fonttools/fonttools/raw/main/Snippets/otf2ttf.py
    python3 ./otf2ttf.py --post-format 2 -o "$subset_ttf" "$subset_otf"

    cd "$OLDPWD"

    go_build "$output_font" \
             NotoSans-Regular.ttf "$subset_ttf" NotoMusic-Regular.ttf \
             NotoSansSymbols-Regular.ttf NotoSansSymbols2-Regular.ttf \
             NotoSansMathSubset-Regular.ttf
}

create_cjk_subset() {
    local input_otf=NotoSansCJKsc-Regular.otf
    local subset_otf="${input_otf/-/Subset-}"
    local subset_ttf="${subset_otf/otf/ttf}"
    local codepoints=""
    local features=""

#    codepoints+="U+2E80-2EFF,"   # CJK radicals supplement
#    codepoints+="U+2F00-2FD5,"   # Kangxi radicals
    codepoints+="U+3000-303F,"   # CJK symbols and punctuation
    codepoints+="U+3100-312F,"   # Bopomofo
    codepoints+="U+31A0-31BF,"   # Bopomofo extended
    codepoints+="U+31C0-31EF,"   # CJK strokes
    codepoints+="U+FE30-FE4F,"   # CJK compatibility forms, used with vertical writing

    # Prepared by first subsetting with --layout-features='*' and then
    # dropping 'vert', 'vhal', 'vkrn', 'vpal', 'vrt2', 'hist'
    features+="aalt,ccmp,dlig,fwid,halt,hwid,kern,liga,locl,palt,pwid"

    if [[ -e "cache/$subset_ttf" ]]; then
        echo "Not overwriting existing font $subset_ttf."
        return
    fi

    cd cache/

    download_url "https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/$input_otf"

    echo "Generating CJK font $subset_ttf. Current time: $(date)."

    download_url "https://www.unicode.org/Public/UCD/latest/ucd/Unihan.zip"
    python3 -m zipfile -e Unihan.zip .
    grep kIICore Unihan_IRGSources.txt | cut -f1 > unihan_iicore.txt

    # Choose U+4e00 to U+6000 to avoid cmap format 4 subtable overflow
    # (reduce number of segments)
    for code in $(seq 0x4e00 0x6000); do
        printf "U+%X\n" "$code"
    done > unihan_range.txt

    # Combine it with IICore codepoints
    cat unihan_iicore.txt unihan_range.txt | sort | uniq > Unihan_codepoints.txt

    # Passthrough tables which cannot be subset
    "$VIRTUAL_ENV"/bin/pyftsubset --drop-tables+=vhea,vmtx --glyph-names \
                  --recommended-glyphs --passthrough-tables --layout-features="$features" \
                  --unicodes-file=Unihan_codepoints.txt --unicodes="$codepoints" \
                  --output-file="$subset_otf" "$input_otf"

    # convert otf to ttf
    download_url https://github.com/fonttools/fonttools/raw/main/Snippets/otf2ttf.py
    python3 ./otf2ttf.py --post-format 2 -o "$subset_ttf" "$subset_otf"
    python3 ../rename_font.py "$subset_ttf" "Noto Sans CJKsc Subset" "NotoSansCJKscSubset"

    cd "$OLDPWD"
}

create_korean_hangul_subset() {
    local input_otf=NotoSansCJKkr-Regular.otf
    local subset_otf="${input_otf/-/Subset-}"
    local subset_ttf="${subset_otf/otf/ttf}"
    local codepoints=""

    if [[ -e "cache/$subset_ttf" ]]; then
        echo "Not overwriting existing font $subset_ttf."
        return
    fi

    codepoints+="U+1100-11FF," # Hangul jamo
    codepoints+="U+3130-318F," # Hangul compatibility jamo
    codepoints+="U+A960-A97F," # Hangul jamo extended-A
    codepoints+="U+D7B0-D7FF," # Hangul jamo extended-B

    cd cache/

    download_url "https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/Korean/$input_otf"

    echo "Generating Korean font $subset_ttf. Current time: $(date)."
    "$VIRTUAL_ENV"/bin/pyftsubset --drop-tables+=vhea,vmtx --glyph-names \
                  --recommended-glyphs --passthrough-tables --layout-features-="vert" \
                  --unicodes="$codepoints" \
                  --output-file="$subset_otf" "$input_otf"

    # convert otf to ttf
    download_url https://github.com/fonttools/fonttools/raw/main/Snippets/otf2ttf.py
    python3 ./otf2ttf.py --post-format 2 -o "$subset_ttf" "$subset_otf"

    python3 ../rename_font.py "$subset_ttf" "Noto Sans CJKkr Subset" "NotoSansCJKkrSubset"

    cd "$OLDPWD"
}

create_japanese_kana_subset() {
    local input_otf=NotoSansCJKjp-Regular.otf
    local subset_otf="${input_otf/-/Subset-}"
    local subset_ttf="${subset_otf/otf/ttf}"
    local codepoints=""
    local features=""

    if [[ -e "cache/$subset_ttf" ]]; then
        echo "Not overwriting existing font $subset_ttf."
        return
    fi

    codepoints+="U+3040-309F,"   # Hiragana
    codepoints+="U+30A0-30FF,"   # Katakana
    codepoints+="U+31F0-31FF,"   # Katakana phonetic extensions
    codepoints+="U+3200-32FF,"   # Enclosed CJK letters and months
    codepoints+="U+3300-33FF,"   # CJK Compatibility
    codepoints+="U+FF00-FFEF,"   # Halfwidth and fullwidth forms
    codepoints+="U+1F200-1F2FF," # Enclosed ideographic supplement

    # Prepared by first subsetting with --layout-features='*' and then
    # dropping 'vert', 'vhal', 'vkrn', 'vpal', 'vrt2'
    features+="aalt,ccmp,dlig,fwid,halt,hwid,kern,liga,locl,palt,pwid"

    cd cache/

    download_url "https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/Japanese/$input_otf"

    echo "Generating Japanese font $subset_ttf. Current time: $(date)."
    "$VIRTUAL_ENV"/bin/pyftsubset --drop-tables+=vhea,vmtx --glyph-names \
                  --recommended-glyphs --passthrough-tables --layout-features="$features" \
                  --unicodes="$codepoints" --output-file="$subset_otf" "$input_otf"

    # convert otf to ttf
    download_url https://github.com/fonttools/fonttools/raw/main/Snippets/otf2ttf.py
    python3 ./otf2ttf.py --post-format 2 -o "$subset_ttf" "$subset_otf"

    python3 ../rename_font.py "$subset_ttf" "Noto Sans CJKjp Subset" "NotoSansCJKjpSubset"

    cd "$OLDPWD"
}

# Indosphere combines South Asia, S.E.Asia and Asia-Historical
create_indosphere_subset() {
    declare -ag GoNotoIndosphere # -a is array, -g is global variable

    GoNotoIndosphere=("${GoNotoSouthAsia[@]}")

    # Exclude fonts which are already included above (avoid duplicates)
    local sea=("${GoNotoSouthEastAsia[@]}")
    sea=("${sea[@]/NotoSans-Regular.ttf/}")
    sea=("${sea[@]/NotoSansSymbols-Regular.ttf/}")
    sea=("${sea[@]/NotoSansSymbols2-Regular.ttf/}")
    sea=("${sea[@]/NotoSansMathSubset-Regular.ttf/}")
    sea=("${sea[@]/NotoMusic-Regular.ttf/}")

    # remove null strings (i.e. '') generaged after find-replace
    sea=($(echo "${sea[@]}" | grep -o '[^[:space:]]\+'))

    GoNotoIndosphere+=("${sea[@]}")
}

go_build() {
    local output="$1"       # name of generated font
    local input=("${@:2}")  # list of fonts to merge

    if [[ -e "$output" ]]; then
        echo "Not overwriting existing font $output."
        return
    fi

    # remove duplicates
    local sorted=($(printf "%s\n" "${input[@]}" \
                       | LC_ALL=C sort --unique \
                       | tr '\n' ' '))

    if [[ "${#input[@]}" -gt "${#sorted[@]}" ]]; then
        echo "ERROR: input list of fonts contains duplicates, len ${#input[@]} > ${#sorted[@]}"
        exit 5
    fi

    cd cache/
    for font in "${input[@]}"; do
        if [[ ! -e "$font" ]]; then
            download_url "${font_urls[$font]}"
        fi
    done

    echo "Merging ${#input[@]} fonts..."
    time "$VIRTUAL_ENV"/bin/pyftmerge --drop-tables+=MATH,vhea,vmtx \
         --verbose --output-file=../"$output" "${input[@]}"

    # Copy line metrics from Noto Sans Regular
    download_url "https://github.com/googlefonts/nototools/raw/main/nototools/substitute_linemetrics.py"
    python3 ./substitute_linemetrics.py --output=../"$output" \
            ../"$output" NotoSans-Regular.ttf

    cd "$OLDPWD"

    edit_font_info "$output"
}
