#!/usr/bin/env python3

import os
import sys

import merge_fonts
import merge_noto

all_regions = {
    'GoNotoSouthAsia.ttf': [
        "NotoSans-Regular.ttf",
        "NotoNastaliqUrdu-Regular.ttf",
        "NotoSansBengali-Regular.ttf",
        "NotoSansChakma-Regular.ttf",
        "NotoSansDevanagari-Regular.ttf",
        "NotoSansGujarati-Regular.ttf",
        "NotoSansGunjalaGondi-Regular.ttf",
        "NotoSansGurmukhi-Regular.ttf",
        "NotoSansKannada-Regular.ttf",
        "NotoSansLepcha-Regular.ttf",
        "NotoSansLimbu-Regular.ttf",
        "NotoSansMalayalam-Regular.ttf",
        "NotoSansMasaramGondi-Regular.ttf",
        "NotoSansMeeteiMayek-Regular.ttf",
        "NotoSansMro-Regular.ttf",
        "NotoSansNewa-Regular.ttf",
        "NotoSansOlChiki-Regular.ttf",
        "NotoSansOriya-Regular.ttf",
        "NotoSansSaurashtra-Regular.ttf",
        "NotoSansSinhala-Regular.ttf",
        "NotoSansTamil-Regular.ttf",
        "NotoSansTelugu-Regular.ttf",
        "NotoSansThaana-Regular.ttf",
        "NotoSerifTibetanSubset-Regular.ttf",
        "NotoSansWancho-Regular.ttf",
        "NotoSansWarangCiti-Regular.ttf",
        # Common for all scripts
        "NotoSansSymbols-Regular.ttf",
        "NotoSansSymbols2-Regular.ttf",
        "NotoSansMath-Regular.ttf",
        "NotoMusic-Regular.ttf",
    ],
    'GoNotoAsiaHistorical.ttf': [
        "NotoSans-Regular.ttf",
        "NotoSansBhaiksuki-Regular.ttf",
        "NotoSansBrahmi-Regular.ttf",
        "NotoSansGrantha-Regular.ttf",
        "NotoSansKaithi-Regular.ttf",
        "NotoSansKharoshthi-Regular.ttf",
        "NotoSansKhudawadi-Regular.ttf",
        "NotoSansMahajani-Regular.ttf",
        "NotoSansMarchen-Regular.ttf",
        "NotoSansModi-Regular.ttf",
        "NotoSansMultani-Regular.ttf",
        "NotoSansNandinagariSubset-Regular.ttf",
        "NotoSansOldSogdian-Regular.ttf",
        "NotoSansOldTurkic-Regular.ttf",
        "NotoSansPhagsPa-Regular.ttf",
        "NotoSansSharada-Regular.ttf",
        "NotoSansSiddham-Regular.ttf",
        "NotoSansSogdian-Regular.ttf",
        "NotoSansSoraSompeng-Regular.ttf",
        "NotoSansSoyombo-Regular.ttf",
        "NotoSansSylotiNagri-Regular.ttf",
        "NotoSansTakri-Regular.ttf",
        "NotoSansTirhuta-Regular.ttf",
        "NotoSansZanabazarSquare-Regular.ttf",
        "NotoSansIndicSiyaqNumbers-Regular.ttf",
        "NotoSerifAhom-Regular.ttf",
        "NotoSerifDograSubset-Regular.ttf",
        "NotoSerifKhojki-Regular.ttf",
        "NotoSerifOldUyghur-Regular.ttf",
        # Common for all scripts
        "NotoSansSymbols-Regular.ttf",
        "NotoSansSymbols2-Regular.ttf",
        "NotoSansMath-Regular.ttf",
        "NotoMusic-Regular.ttf",
    ],
    'GoNotoSouthEastAsia.ttf': [
        "NotoSans-Regular.ttf",
        "NotoSansBalinese-Regular.ttf",
        "NotoSansBatak-Regular.ttf",
        "NotoSansBuginese-Regular.ttf",
        "NotoSansBuhid-Regular.ttf",
        "NotoSansCham-Regular.ttf",
        "NotoSansHanifiRohingya-Regular.ttf",
        "NotoSansHanunoo-Regular.ttf",
        "NotoSansJavanese-Regular.ttf",
        "NotoSansKayahLi-Regular.ttf",
        "NotoSansKhmer-Regular.ttf",
        "NotoSansLao-Regular.ttf",
        # "NotoSansMakasar-Regular.ttf", # doesn't exist
        "NotoSansMyanmar-Regular.ttf",
        "NotoSansNewTaiLue-Regular.ttf",
        "NotoSansPahawhHmong-Regular.ttf",
        "NotoSerifNyiakengPuachueHmong-Regular.ttf",
        "NotoSansPauCinHau-Regular.ttf",
        "NotoSansRejang-Regular.ttf",
        "NotoSansSundanese-Regular.ttf",
        "NotoSansTagalog-Regular.ttf",
        "NotoSansTagbanwa-Regular.ttf",
        "NotoSansTaiLe-Regular.ttf",
        "NotoSansTaiTham-Regular.ttf",
        "NotoSansTaiViet-Regular.ttf",
        "NotoSansThai-Regular.ttf",
        # Common for all scripts
        "NotoSansSymbols-Regular.ttf",
        "NotoSansSymbols2-Regular.ttf",
        "NotoSansMath-Regular.ttf",
        "NotoMusic-Regular.ttf",
    ],
    'GoNotoEuropeAmericas.ttf': [
        "NotoSans-Regular.ttf",
        "NotoSansArmenian-Regular.ttf",
        "NotoSansCherokee-Regular.ttf",
        "NotoSansCoptic-Regular.ttf",
        "NotoSansDeseret-Regular.ttf",
        "NotoSansGeorgian-Regular.ttf",
        "NotoSansGlagolitic-Regular.ttf",
        "NotoSansOsage-Regular.ttf",
        "NotoSansSignWriting-Regular.ttf",
        "NotoSerifNyiakengPuachueHmong-Regular.ttf",
        # Historical
        "NotoSansCypriot-Regular.ttf",
        "NotoSansCaucasianAlbanian-Regular.ttf",
        "NotoSansCarian-Regular.ttf",
        "NotoSansCanadianAboriginal-Regular.ttf",
        "NotoSansLinearA-Regular.ttf",
        "NotoSansLinearB-Regular.ttf",
        "NotoSansLycian-Regular.ttf",
        "NotoSansLydian-Regular.ttf",
        "NotoSansAnatolianHieroglyphs-Regular.ttf",
        "NotoSansOldItalic-Regular.ttf",
        "NotoSansRunic-Regular.ttf",
        "NotoSansOldHungarian-Regular.ttf",
        "NotoSansGothic-Regular.ttf",
        "NotoSansElbasan-Regular.ttf",
        "NotoSansCaucasianAlbanian-Regular.ttf",
        "NotoSansVithkuqi-Regular.ttf",
        "NotoSansOgham-Regular.ttf",
        "NotoSansOldPermic-Regular.ttf",
        "NotoSansShavian-Regular.ttf",
        "NotoSansDuployan-Regular.ttf",
        "NotoSansMayanNumerals-Regular.ttf",
        # Common for all scripts
        "NotoSansSymbols-Regular.ttf",
        "NotoSansSymbols2-Regular.ttf",
        "NotoSansMath-Regular.ttf",
        "NotoMusic-Regular.ttf",
    ],
    'GoNotoAfricaMiddleEast.ttf': [
        "NotoSans-Regular.ttf",
        "NotoNaskhArabic-Regular.ttf", # or "NotoSansArabic-Regular.ttf"
        "NotoSansAdlam-Regular.ttf",
        "NotoSansBamum-Regular.ttf",
        "NotoSansBassaVah-Regular.ttf",
        "NotoSansHebrew-Regular.ttf",
        "NotoSansSyriac-Regular.ttf",
        "NotoSansSamaritan-Regular.ttf",
        "NotoSansMandaic-Regular.ttf",
        "NotoSerifYezidi-Regular.ttf",
        # Historical scripts
        "NotoSansOldNorthArabian-Regular.ttf",
        "NotoSansOldSouthArabian-Regular.ttf",
        "NotoSansPhoenician-Regular.ttf",
        "NotoSansImperialAramaic-Regular.ttf",
        "NotoSansManichaean-Regular.ttf",
        "NotoSansInscriptionalParthian-Regular.ttf",
        "NotoSansInscriptionalPahlavi-Regular.ttf",
        "NotoSansPsalterPahlavi-Regular.ttf",
        "NotoSansAvestan-Regular.ttf",
        # "NotoSansChorasmian-Regular.ttf", # doesn't exist
        "NotoSansElymaic-Regular.ttf",
        "NotoSansNabataean-Regular.ttf",
        "NotoSansPalmyrene-Regular.ttf",
        "NotoSansHatran-Regular.ttf",
        # Cuneiform and Hieroglyphs
        "NotoSansCuneiform-Regular.ttf",
        "NotoSansUgaritic-Regular.ttf",
        "NotoSansOldPersian-Regular.ttf",
        "NotoSansEgyptianHieroglyphs-Regular.ttf",
        "NotoSansMeroitic-Regular.ttf",
        "NotoSansAnatolianHieroglyphs-Regular.ttf",
        # Africa
        "NotoSansEthiopic-Regular.ttf",
        "NotoSansOsmanya-Regular.ttf",
        "NotoSansTifinagh-Regular.ttf", # TODO: check Tifinagh variants
        "NotoSansNKo-Regular.ttf",
        "NotoSansVai-Regular.ttf",
        "NotoSansMendeKikakui-Regular.ttf",
        "NotoSansMedefaidrin-Regular.ttf",
        # Common for all scripts
        "NotoSansSymbols-Regular.ttf",
        "NotoSansSymbols2-Regular.ttf",
        "NotoSansMath-Regular.ttf",
        "NotoMusic-Regular.ttf",
    ],
    'GoNotoEastAsia.ttf': [
        "NotoSans-Regular.ttf",
        "NotoSansMarchen-Regular.ttf",
        "NotoSansMongolianSubset-Regular.ttf",
        "NotoSansOldSogdian-Regular.ttf",
        "NotoSansOldTurkic-Regular.ttf",
        "NotoSansPhagsPa-Regular.ttf",
        "NotoSansSogdian-Regular.ttf",
        "NotoSansSoyombo-Regular.ttf",
        "NotoSansZanabazarSquare-Regular.ttf",
        "NotoSerifTibetanSubset-Regular.ttf",
        "NotoSansYi-Regular.ttf",
        "NotoSansNushuSubset-Regular.ttf",
        "NotoSansLisu-Regular.ttf",
        "NotoSansMiao-Regular.ttf",
        "NotoSerifTangutSubset-Regular.ttf",
        # Common for all scripts
        "NotoSansSymbols-Regular.ttf",
        "NotoSansSymbols2-Regular.ttf",
        "NotoSansMath-Regular.ttf",
        "NotoMusic-Regular.ttf",
    ],
}

def download_fonts(directory="./"):
    """Download all the fonts in the @c files list"""
    from urllib.request import urlretrieve
    from time import sleep
    url_base = "https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/%s/%s"
    for ttf in merge_fonts.files:
        outfile = os.path.join(directory, ttf)
        if os.path.exists(outfile): continue
        url = url_base % (ttf.split('-')[0], ttf)
        print("Fetching %s" % url)
        try:
            urlretrieve(url, outfile)
        except:
            print("Could not retrieve %s. Please check if it exists", ttf)
        sleep(0.5) # poor man's rate-limiting

# append new entries from # https://docs.microsoft.com/en-gb/typography/opentype/spec/scripttags
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['TaiLe'] = 'tale'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Multani'] = 'mult'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['SoraSompeng'] = 'sora'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['NewTaiLue'] = 'talu'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['TaiViet'] = 'tavt'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Rejang'] = 'rjng'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Tagalog'] = 'tglg'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Tagbanwa'] = 'tagb'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Thaana'] = 'thaa'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Mro'] = 'mroo'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['PahawhHmong'] = "hmng"
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Bamum'] = "bamu"
# TODO Why does this begin with 'NotoSerif'?
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['NotoSerifYezidi'] = "yezi"
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Nushul'] = "nshu"
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['LinearA'] = "lina"
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['AnatolianHieroglyphs'] = 'hluw'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Vithkuqi'] = 'vith'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['OldPermic'] = 'perm'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['OldNorthArabian'] = 'narb'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Nabataean'] = 'nbat'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Hatran'] = 'hatr'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Medefaidrin'] = 'medf'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Duployan'] = 'dupl'
# TODO: NotoSansMayanNumerals-Regular.ttf does not contain any script tag at all!
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['MayanNumerals'] = 'maya'
# TODO Why does this begin with 'NotoSerif'?
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['NotoSerifNyiakengPuachueHmong'] = 'hmnp'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['SignWriting'] = 'sgnw'
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['Mahajani'] = 'mahj'
# TODO Why's this decuding 'Subset'?
merge_noto.SCRIPT_TO_OPENTYPE_SCRIPT_TAG['NushuSubset'] = 'nshu'

if __name__ == "__main__":
    merge_fonts.files = all_regions[sys.argv[2]]
    download_fonts(sys.argv[4])
    merge_fonts.main()
