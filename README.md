# Go Noto Universal

Utility to combine/merge multiple [Noto
Fonts](https://github.com/googlefonts/noto-fonts) to regional
variants.


## Instructions

Create a virtual environment (venv) and call `./run.sh`.

```
python3 -m venv venv_fonty
source venv_fonty/bin/activate
./run.sh
deactivate
```
## Dependencies

There is no dependency other than [`nototools`](https://github.com/googlefonts/nototools) and
[`fonttools`](https://github.com/fonttools/fonttools/). Both are automatically fetched and used.

## Coverage

Fonts are merged/combined as per the regions defined in the [Unicode Standard
(pdf)](https://www.unicode.org/versions/Unicode14.0.0/UnicodeStandard-14.0.pdf) Chapter numbers
refer to that spec.

| Regional font              | Coverage                                                                             |
|----------------------------|--------------------------------------------------------------------------------------|
| GoNotoSouthAsia.ttf        | "South and Central Asia" - ch. 12 and 13                                             |
| GoNotoAsiaHistorical.ttf   | "South and Central Asia" - ch. 14 and 15                                             |
| GoNotoSouthEastAsia.ttf    | "Southeast Asia" ch. 16 and "Indonesia and Ocenia" - ch 17                           |
| GoNotoEuropeAmericas.ttf   | "Europe" - ch. 7 and 8                                                               |
| GoNotoAfricaMiddleEast.ttf | "Africa" - ch. 19 and "Middle East" - ch. 9 and 10                                   |
| GoNotoEastAsia.ttf         | "East Asia" - ch 18. everything other than Han (CJK)                                 |
| GoNotoCJK.ttf              | [Noto CJK](https://github.com/googlefonts/noto-cjk/blob/main/Sans/README-formats.md) |


All of the above fonts include LGC (Latin-Greek-Cyrillic) as default, same coverage as `Noto Sans
Regular`.

## Caveats

1. You might have to increase line spacing or line margins in your application to avoid some
   characters appearing "clipped". This is because many Asian scripts stack letters vertically
   (e.g. Indic scripts, Thai, Balinese etc.) but the line metrics of the merged font are
   optimized for LGC.
2. Tibetan has limited glyphs, otherwise GSUB table gets "overrflow"ed. Only the most frequently
   occuring "subjoined consonants" are included. Those characters are displayed ok, but just that
   the glyphs appear to be "pushed up" compared to their neighbours.
3. Certain fonts just refuse to cooperate, e.g. Mongolian, Nushu.

<!--
1891 glyphs -> GSUB LookupIndex 1293 fails
1575 glyphs -> GSUB LookupIndex 646 fails. Max Lookuptable size = 1651
(NoSubjoined) 168 code points, 688 glpyhs -> GSUB LookupCount 1680

../venv_fonty/bin/pyftsubset  NotoSerifTibetan-Regular.ttf \
    --unicodes=U+0F00-0F8C,U+0F90,U+0F94,U+0F95,U+0F97,U+0F9F,U+0FA1,U+0FA3,U+0FA4,\
    U+0FA6,U+0FA9,U+0FAB,U+0FAD,U+0FAF,U+0FB1-0FB3,U+0FB06-0FB8,U+0FBE-0FDA
=> gives 181 codepoints, 1380 glyphs, 401KB size, GSUB LookupCount 915

In comparison, Devanagari has GSUB LookupCount = 120 just!

--unicodes=U+0F00-0F68,U+0F6B-0F87,U+0F90,U+0F94,U+0F95,U+0F97,U+0F
9F,U+0FA1,U+0FA3,U+0FA4,U+0FA6,U+0FA9,U+0FAB,U+0FAD,U+0FAF,U+0FB1-0FB3,U+0FB06-0FB8,U+0FBE-0FDA

=> gives 174 codepoints, 1322 glyphs, 385KB size, GSUB LookupCount 892

-ka, -ga, -ja, -ta, -da, -na, -pa, -ba, -ma, -ya, -ra, -la, -wa, -tsa, -ha

Bhutanese/Tibetan only:

 --unicodes=U+0F00-0F8F,U+0F90,U+0F92,U+0F97,U+0F9F,u+0FA1,U+0FA3,U+0FA4,U+0FA6,U+0FA8,U+0FA9,U+0FAD,U+0FB1-0FB3,U+0FB7

155 codepoints, 1435 glyphs, 426 KB,

 --unicodes=U+0F00-0F8C,U+0F90,U+0F92,U+0F97,U+0F9F,u+0FA1,U+0FA3,U+0FA4,U+0FA6,U+0FA8,U+0FA9,U+0FAD,U+0FB1-0FB3,U+0FB8,U+0FBE-0FDA

180 codepoints, 1456 glyphs, 431KB, GSUB 988 lookup ==> Not working

 --unicodes=U+0F00-0F8C,U+0F90,U+0F92,U+0F94,U+0FF99,U+0FAD,U+0FB1-0FB3,U+0FBA-0FDA

175 codepoints, 1023 glyphs, 285KB, GSUB 646 lookup ==> WORKS WITH EastAsia.ttf and SouthAsia.ttf!

  --unicodes=U+0F00-0F8C,U+0F90,U+0F92,U+0F94,U+0F9F,U+0FF99,U+0FAD,U+0FB1-0FB3,U+0FBA-0FDA
(added TA) 176 codepoints, 1096 glyphs, 309KB, GSUB 703

 --unicodes=U+0F00-0F8C,U+0F90,U+0F92,U+0F94,U+0F99,U+0F9F,U+0FA4,U+0FAD,U+0FB1-0FB3,U+0FBA-0FDA
(added TA, PA) 178 codepoints, 1170 glyphs, 330KB, GSUB 749

 --unicodes=U+0F00-0F8C,U+0F90,U+0F92,U+0F94,U+0F99,U+0F9F,U+0FA4,U+0FA9,U+0FAD,U+0FB1-0FB3,U+0FBA-0FDA
(added TA, PA, TSA) 179 codepoints, 1204 glyphs, 343KB, GSUB 771 ==> WORKS!
-->
