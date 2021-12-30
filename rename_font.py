#!/usr/bin/env python3

"""Edit metadata about font names"""

import sys
from subprocess import check_output
from fontTools.ttLib import TTFont

fontname = sys.argv[1]
name_with_spaces = sys.argv[2]
name_without_spaces = sys.argv[3]

git_hash = lambda: check_output(['git', 'rev-parse', '--short', 'HEAD']).decode('ascii').strip()

font = TTFont(fontname)

# https://docs.microsoft.com/en-gb/typography/opentype/spec/name
for record in font['name'].names:
    if record.nameID == 1: # font family name
        family = record.toStr()
    elif record.nameID == 2: # font style
        subfamily = record.toStr()
        new_postscript_name = name_without_spaces + "-" + subfamily
    elif record.nameID == 6: # postscript name
        postscript_name = record.toStr()
    elif record.nameID == 10: # description
        description = record.toStr()

for record in font['name'].names:
    encoding = record.getEncoding()
    if record.nameID == 1: # font family name
        record.string = name_with_spaces.encode(encoding)
    elif record.nameID == 3: # unique id
        uniq_id = record.toStr()
        new_uniq_id = uniq_id.replace(postscript_name, new_postscript_name)
        record.string = new_uniq_id.encode(encoding)
    elif record.nameID == 4: # full name
        new_name = name_with_spaces + " " + subfamily
        record.string = new_name.encode(encoding)
    elif record.nameID == 6: # postscript name
        record.string = new_postscript_name.encode(encoding)
    elif record.nameID == 10: # description
        record.string = (description +
                         " The Go Noto Universal project merged many upstream Noto Fonts to produce this font."
                        ).encode(encoding)
    elif record.nameID == 11: # vendor URL
        record.string = ("https://github.com/satbyy/go-noto-universal/tree/" +
                         git_hash()).encode(encoding)

font.save(fontname)
font.close()
