#!/usr/bin/env python3

import os
import sys

import merge_fonts
import merge_noto

all_regions = {
    'GoNotoSouthAsia.ttf': [
        "NotoSans-Regular.ttf",
        "NotoSansDevanagari-Regular.ttf",
    ],
    'GoNotoSouthEastAsia.ttf': [
        "NotoSans-Regular.ttf",
        "NotoSansThai-Regular.ttf",
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
        urlretrieve(url, outfile)
        sleep(0.5)

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

if __name__ == "__main__":
    merge_fonts.files = all_regions[sys.argv[2]]
    download_fonts(sys.argv[4])
    merge_fonts.main()
