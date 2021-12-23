#!/usr/bin/env bash
set -e

# export these variables
declare -x current
declare -x ancient

ancient=(
    "NotoSans-Regular.ttf"
    # 'GoNotoAsiaHistorical.ttf': [
    "NotoSansBhaiksuki-Regular.ttf"
    "NotoSansBrahmi-Regular.ttf"
    "NotoSansGrantha-Regular.ttf"
    "NotoSansKaithi-Regular.ttf"
    "NotoSansKharoshthi-Regular.ttf"
    "NotoSansKhudawadi-Regular.ttf"
    "NotoSansMahajani-Regular.ttf"
    "NotoSansModi-Regular.ttf"
    "NotoSansMultani-Regular.ttf"
    "NotoSansNandinagariSubset-Regular.ttf"
    "NotoSansOldSogdian-Regular.ttf"
    "NotoSansOldTurkic-Regular.ttf"
    "NotoSansPhagsPa-Regular.ttf"
    "NotoSansSharada-Regular.ttf"
    "NotoSansSiddham-Regular.ttf"
    "NotoSansSogdian-Regular.ttf"
    "NotoSansSoraSompeng-Regular.ttf"
    "NotoSansSoyombo-Regular.ttf"
    "NotoSansSylotiNagri-Regular.ttf"
    "NotoSansTakri-Regular.ttf"
    "NotoSansTirhuta-Regular.ttf"
    "NotoSansZanabazarSquare-Regular.ttf"
    "NotoSerifAhom-Regular.ttf"
    "NotoSerifDograSubset-Regular.ttf"
    "NotoSerifKhojki-Regular.ttf"
    # 'GoNotoEuropeAmericas.ttf': [
    "NotoSansCypriot-Regular.ttf"
    "NotoSansCaucasianAlbanian-Regular.ttf"
    "NotoSansCarian-Regular.ttf"
    "NotoSansCanadianAboriginal-Regular.ttf"
    "NotoSansLinearA-Regular.ttf"
    "NotoSansLinearB-Regular.ttf"
    "NotoSansLycian-Regular.ttf"
    "NotoSansLydian-Regular.ttf"
    "NotoSansAnatolianHieroglyphs-Regular.ttf"
    "NotoSansOldItalic-Regular.ttf"
    "NotoSansRunic-Regular.ttf"
    "NotoSansOldHungarian-Regular.ttf"
    "NotoSansGothic-Regular.ttf"
    "NotoSansElbasan-Regular.ttf"
    "NotoSansCaucasianAlbanian-Regular.ttf"
    "NotoSansVithkuqi-Regular.ttf"
    "NotoSansOgham-Regular.ttf"
    "NotoSansOldPermic-Regular.ttf"
    "NotoSansShavian-Regular.ttf"
    "NotoSansDuployan-Regular.ttf"
    "NotoSansMayanNumerals-Regular.ttf"
    # 'GoNotoAfricaMiddleEast.ttf': [
    "NotoSansOldNorthArabian-Regular.ttf"
    "NotoSansOldSouthArabian-Regular.ttf"
    "NotoSansPhoenician-Regular.ttf"
    "NotoSansImperialAramaic-Regular.ttf"
    "NotoSansManichaean-Regular.ttf"
    "NotoSansInscriptionalParthian-Regular.ttf"
    "NotoSansInscriptionalPahlavi-Regular.ttf"
    "NotoSansPsalterPahlavi-Regular.ttf"
    "NotoSansAvestan-Regular.ttf"
    # "NotoSansChorasmian-Regular.ttf" # doesn't exist
    "NotoSansElymaic-Regular.ttf"
    "NotoSansNabataean-Regular.ttf"
    "NotoSansPalmyrene-Regular.ttf"
    "NotoSansHatran-Regular.ttf"
    # Cuneiform and Hieroglyphs
    "NotoSansCuneiform-Regular.ttf"
    "NotoSansUgaritic-Regular.ttf"
    "NotoSansOldPersian-Regular.ttf"
    "NotoSansEgyptianHieroglyphs-Regular.ttf"
    "NotoSansMeroitic-Regular.ttf"
    "NotoSansAnatolianHieroglyphs-Regular.ttf"
    # 'GoNotoEastAsia.ttf': [
    "NotoSansMarchen-Regular.ttf"
    "NotoSerifTangutSubset-Regular.ttf"
    # Common for all scripts
    "NotoSansSymbols-Regular.ttf"
    "NotoSansSymbols2-Regular.ttf"
    "NotoSansMath-Regular.ttf"
    "NotoMusic-Regular.ttf"
)

current=(
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
    "NotoSansCJKjpSubset-Regular.ttf"
    "NotoSansCJKkrSubset-Regular.ttf"
    "NotoSansCJKscSubset-Regular.ttf"
    "NotoSansMongolianSubset-Regular.ttf"
    "NotoSansYi-Regular.ttf"
    "NotoSansNushuSubset-Regular.ttf" # Not exactly contemporary use but just 402 glyphs
    "NotoSansMiao-Regular.ttf"
    # Common for all scripts
    "NotoSansSymbols-Regular.ttf"
    "NotoSansSymbols2-Regular.ttf"
    "NotoSansMath-Regular.ttf"
    "NotoMusic-Regular.ttf"
)
