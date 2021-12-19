#!/bin/bash

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
    # Common for all scripts
    "NotoSansSymbols-Regular.ttf"
    "NotoSansSymbols2-Regular.ttf"
    "NotoSansMath-Regular.ttf"
)

cd cached_fonts/

# CJK subset from different URL
# wget -nv -O NotoSansCJKsc-VF.ttf https://github.com/googlefonts/noto-cjk/raw/main/Sans/Variable/TTF/NotoSansCJKsc-VF.ttf

for font in "${contemporary[@]}"; do
    if [[ ! -e "$font" ]]; then
        noto_dir="${font%-*}"
        wget -O "$font" -nv "https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/$noto_dir/$font"
    fi
done

time pyftmerge --verbose --drop-tables=vhea,vmtx \
     --output-file=../GoNotoContemporary.ttf "${contemporary[@]}"

cd "$OLDPWD"

python3 ./rename_font.py GoNotoContemporary.ttf \
        "Go Noto Contemporary" GoNotoContemporary
