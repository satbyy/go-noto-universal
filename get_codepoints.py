#!/usr/bin/env python3

"""Dumps all the codepoints covered in a given font, one per line"""

import sys
from fontTools.ttLib import TTFont

with TTFont(sys.argv[1]) as ttf:
   for x in ttf["cmap"].tables:
       for code in x.cmap:
           print("U+%06X" % code)
