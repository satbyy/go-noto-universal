#!/bin/bash -e

historical=(
    "NotoSans-Regular.ttf"
   # "NotoSansMarchen-Regular.ttf" # historical not needed?
    # 'GoNotoAsiaHistorical.ttf': [
    "NotoSansBhaiksuki-Regular.ttf"
    "NotoSansBrahmi-Regular.ttf"
    "NotoSansGrantha-Regular.ttf"
    "NotoSansKaithi-Regular.ttf"
    "NotoSansKharoshthi-Regular.ttf"
    "NotoSansKhudawadi-Regular.ttf"
    "NotoSansMahajani-Regular.ttf"
    # "NotoSansMarchen-Regular.ttf" # historical not needed?
    "NotoSansModi-Regular.ttf"
    "NotoSansMultani-Regular.ttf"
    "NotoSansNandinagari-Regular.ttf" # doesn't exist
    # "NotoSansOldSogdian-Regular.ttf"
    # "NotoSansOldTurkic-Regular.ttf"
    # "NotoSansPhagsPa-Regular.ttf"
    "NotoSansSharada-Regular.ttf"
    "NotoSansSiddham-Regular.ttf"
    # "NotoSansSogdian-Regular.ttf"
    "NotoSansSoraSompeng-Regular.ttf"
    # "NotoSansSoyombo-Regular.ttf"
    "NotoSansSylotiNagri-Regular.ttf"
    "NotoSansTakri-Regular.ttf"
    "NotoSansTirhuta-Regular.ttf"
    # "NotoSansZanabazarSquare-Regular.ttf"
    "NotoSerifAhom-Regular.ttf"
    "NotoSerifDogra-Regular.ttf"
    "NotoSerifKhojki-Regular.ttf"
)

contemporary=(
    # It's recommended to put NotoSans-Regular.ttf as the first element in the
    # list to maximize the amount of meta data retained in the final merged font.
    # ------- South Asia ---------
    "NotoSans-Regular.ttf"
    "NotoSansArabic-Regular.ttf" # "NotoNastaliqUrdu-Regular.ttf"
    "NotoSansBengali-Regular.ttf"
    "NotoSansChakma-Regular.ttf"
    "NotoSansDevanagari-Regular.ttf"
    "NotoSansGujarati-Regular.ttf"
    "NotoSansGunjalaGondi-Regular.ttf"
    "NotoSansGurmukhi-Regular.ttf"
    "NotoSansKannada-Regular.ttf"
    "NotoSansLepcha-Regular.ttf"
    "NotoSansLimbu-Regular.ttf"
    "NotoSansMalayalam-Regular.ttf"
    "NotoSansMasaramGondi-Regular.ttf"
    "NotoSansMeeteiMayek-Regular.ttf"
    "NotoSansMro-Regular.ttf"
    "NotoSansNewa-Regular.ttf"
    "NotoSansOlChiki-Regular.ttf"
    "NotoSansOriya-Regular.ttf"
    "NotoSansSaurashtra-Regular.ttf"
    "NotoSansSinhala-Regular.ttf"
    "NotoSansTamil-Regular.ttf"
    "NotoSansTelugu-Regular.ttf"
    "NotoSansThaana-Regular.ttf"
    "NotoSerifTibetanSubset-Regular.ttf"
    "NotoSansWancho-Regular.ttf"
    "NotoSansWarangCiti-Regular.ttf"
    # SE Asia
    "NotoSansBalinese-Regular.ttf"
    "NotoSansBatak-Regular.ttf"
    "NotoSansBuginese-Regular.ttf"
    "NotoSansBuhid-Regular.ttf"
    "NotoSansCham-Regular.ttf"
    "NotoSansHanifiRohingya-Regular.ttf"
    "NotoSansHanunoo-Regular.ttf"
    "NotoSansJavanese-Regular.ttf"
    "NotoSansKayahLi-Regular.ttf"
    "NotoSansKhmer-Regular.ttf"
    "NotoSansLao-Regular.ttf"
    "NotoSansMyanmar-Regular.ttf"
    "NotoSansNewTaiLue-Regular.ttf"
    "NotoSansPahawhHmong-Regular.ttf"
    "NotoSansPauCinHau-Regular.ttf"
    "NotoSansRejang-Regular.ttf"
    "NotoSansSundanese-Regular.ttf"
    "NotoSansTagalog-Regular.ttf"
    "NotoSansTagbanwa-Regular.ttf"
    "NotoSansTaiLe-Regular.ttf"
    "NotoSansTaiTham-Regular.ttf"
    "NotoSansTaiViet-Regular.ttf"
    "NotoSansThai-Regular.ttf"
    "NotoSansLisu-Regular.ttf"
    # 'GoNotoEuropeAmericas.ttf': [
    "NotoSans-Regular.ttf"
    "NotoSansArmenian-Regular.ttf"
    "NotoSansCherokee-Regular.ttf"
    "NotoSansCoptic-Regular.ttf"
    "NotoSansCypriot-Regular.ttf"
    "NotoSansDeseret-Regular.ttf"
    "NotoSansGeorgian-Regular.ttf"
    "NotoSansGlagolitic-Regular.ttf"
    "NotoSansOsage-Regular.ttf"
    # 'GoNotoAfricaMiddleEast.ttf': [
    "NotoSansAdlam-Regular.ttf"
    "NotoSansBamum-Regular.ttf"
    "NotoSansBassaVah-Regular.ttf"
    "NotoSansHebrew-Regular.ttf"
    "NotoSansSyriac-Regular.ttf"
    "NotoSansSamaritan-Regular.ttf"
    "NotoSansMandaic-Regular.ttf"
    "NotoSerifYezidi-Regular.ttf"
    "NotoSansEthiopic-Regular.ttf"
    "NotoSansOsmanya-Regular.ttf"
    "NotoSansTifinagh-Regular.ttf"
    "NotoSansNKo-Regular.ttf"
    "NotoSansVai-Regular.ttf"
    "NotoSansMendeKikakui-Regular.ttf"
    "NotoSansMedefaidrin-Regular.ttf"
    # 'GoNotoEastAsia.ttf': [
    "NotoSansCJKscSubset-Regular.ttf" # we'll create this below
    "NotoSansMongolianSubset-Regular.ttf"
    "NotoSansYi-Regular.ttf"
    "NotoSansNushuSubset-Regular.ttf" # Not exactly contemporary use but just 402 glyphs
    "NotoSansMiao-Regular.ttf"
    # Common for all scripts
    "NotoSansSymbols-Regular.ttf"
    "NotoSansSymbols2-Regular.ttf"
    "NotoSansMath-Regular.ttf"
)

create_cjk_subset() {
    local input_otf=NotoSansCJKsc-Regular.otf
    local subset_otf="${input_otf/-/Subset-}"
    local subset_ttf="${subset_otf/otf/ttf}"

    mkdir -p cached_fonts/ && cd cached_fonts/

    # CJK font from different URL
    if [[ ! -e "$input_otf" || ! -e "$subset_ttf" ]]; then
        wget -nv -O "$input_otf" https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/"$input_otf"

        [[ ! -e Unihan.zip ]] && wget -nv https://www.unicode.org/Public/UCD/latest/ucd/Unihan.zip
        python3 -m zipfile -e Unihan.zip .
        grep kIICore Unihan_IRGSources.txt | cut -f1 > unihan_iicore.txt

        # Chooose U+4e00 to U+6000 to avoid cmap format 4 subtable overflow (reduce number of segments)
        for i in $(seq 0x4e00 0x6000); do printf "U+%x\n" $i; done > unihan_0x4e00-0x6000.txt

        # Combine it with IICore codepoints
        cat unihan_iicore.txt unihan_0x4e00-0x6000.txt | sort | uniq > Unihan_codepoints.txt

        # Passthrough tables which cannot be subset
        "$VIRTUAL_ENV"/bin/pyftsubset --drop-tables=vhea,vmtx --glyph-names --recommended-glyphs --passthrough-tables \
                      --layout-features='*' --unicodes-file=Unihan_codepoints.txt --output-file="$subset_otf" "$input_otf"

        # convert otf to ttf
        wget -N -nv https://github.com/fonttools/fonttools/raw/main/Snippets/otf2ttf.py
        python3 ./otf2ttf.py --post-format 3 -o "$subset_ttf" "$subset_otf"
    fi

    cd "$OLDPWD"
}

create_cjk_subset

mkdir -p cached_fonts/ && cd cached_fonts/
for font in "${contemporary[@]}"; do
    if [[ ! -e "$font" ]]; then
        noto_dir="${font%-*}"
        wget -O "$font" -nv "https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/$noto_dir/$font"
    fi
done

time "$VIRTUAL_ENV"/bin/pyftmerge --drop-tables+=vhea,vmtx --verbose --output-file=../GoNotoContemporary.ttf "${contemporary[@]}"

cd "$OLDPWD"

python3 ./rename_font.py GoNotoContemporary.ttf "Go Noto Contemporary" GoNotoContemporary
