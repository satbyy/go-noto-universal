# Go Noto Universal

Noto Fonts go universal! Did you ever want "one font for all languages"? Download pan-Unicode, [Noto
Fonts](https://github.com/googlefonts/noto-fonts) merged according to the time of usage (current,
ancient) or geographical region (Africa-MiddleEast, Europe-Americas, South Asia, SE Asia).

We offer two types of combined fonts:

1. Time-based:  
   - **GoNotoCurrent.ttf** covers pretty much all the scripts in current, widespread use all over the
     world. This is designed to be a "good enough" font for modern, living scripts without being
     exhaustive.
   - **GoNotoAncient.ttf** covers all the historical, obsolete and liturgical scripts.
2. Region-based:  
   Choose a single font based on where you live or whichever region you're interested in:
   Africa - Middle East, East Asia, Europe - Americas, South Asia or South East Asia.

See [caveats](#caveats) too.

## Download

If you simply want to _use_ the fonts, go to [Releases page](https://github.com/satbyy/go-noto-universal/releases/)
and download what you need. If you're unsure what to download, you probably need GoNotoCurrent.ttf.

Development builds are available from [GitHub
Actions](https://github.com/satbyy/go-noto-universal/actions) page. Click on any workflow with green
checkmark ✅ (pipeline passed) and under "Artifacts", download "GoNotoTemporalFonts.zip" and
"GoNotoRegionalFonts.zip" (login required).

> **_NOTE:_** Even if there are no regular commits to this repo, the CI pipeline builds new Go Noto
> fonts everyday, pulling the latest Noto Fonts from upstream (using a scheduled cron). So, download
> the "Artifacts" from the "Actions" page to get the best features and bug fixes from Noto Fonts.

## Build

If you want to _build_ the fonts yourself, create a virtual environment (venv) and run the script
you want:

```
python3 -m venv venv_fonty
source venv_fonty/bin/activate
./temporal_fonts.sh  # generates GoNotoAncient.ttf and GoNotoCurrent.ttf
./regional_fonts.sh  # generates GoNoto[AfricaMiddleEast|EuropeAmericas|...].ttf
deactivate
```

Font generation can take 15 to 30 min, depending on your computer's capabilities.

Each script is designed to be reentrant, so you can run it multiple times without altering the
working state of the repository or downloading stuff again and again.

Latest CI status:

[![Regional fonts](https://github.com/satbyy/go-noto-universal/actions/workflows/regional_fonts.yml/badge.svg)](https://github.com/satbyy/go-noto-universal/actions/workflows/regional_fonts.yml)

[![Temporal fonts](https://github.com/satbyy/go-noto-universal/actions/workflows/temporal_fonts.yml/badge.svg)](https://github.com/satbyy/go-noto-universal/actions/workflows/temporal_fonts.yml)


## Dependencies

[`fonttools`](https://github.com/fonttools/fonttools/) is automatically fetched and used. The main
programs we use are `pyftmerge`, `pyftsubset` and `ttx`.


## Coverage

### Temporal Fonts

Temporal, i.e., time-based fonts are:

- **Go Noto Current** -- combines 80+ Noto Fonts of scripts which are in current, daily usage. It is
  a superset of all the "[Regional Fonts](#regional-fonts)" (see below) excluding historical or
  specialty fonts. It includes support for Chinese, Japanese and Korean (CJK) too, using the [Unihan
  IICore][1] subset.
- **Go Noto Ancient** -- combines 70+ Noto Fonts of ancient, historical or liturgical scripts which
  are not used widely today. This font is probably useful for research or scholarly purposes or
  language enthusiasts. This font does not support any CJK.

Each of these fonts includes Noto Sans (Regular), Noto Sans Symbols, Noto Sans Symbols 2, Noto Sans
Math and Noto Music so that notations, symbols and emoji are not missed out.

Serif variants of these are also included but their Unicode coverage is not as good as Sans Serif
(lack of upstream Noto Serif fonts).

The exact fonts which are combined are too long to list here but can be seen from the source code.

### Regional Fonts

These fonts are merged/combined as per the regions defined in the [Unicode Standard
(pdf)](https://www.unicode.org/versions/Unicode15.0.0/UnicodeStandard-15.0.pdf). Chapter numbers
below refer to that spec.

| Go Noto font               | Coverage                                                                                 |
|----------------------------|------------------------------------------------------------------------------------------|
| GoNotoEuropeAmericas.ttf   | "Europe" - ch. 7, 8, "Americas" - ch 20, "Notational Systems" - ch 21                    |
| GoNotoAfricaMiddleEast.ttf | "Middle East" - ch. 9, 10, 11 and "Africa" - ch. 19                                      |
| GoNotoSouthAsia.ttf        | "South and Central Asia" - ch. 12 and 13                                                 |
| GoNotoAsiaHistorical.ttf   | "South and Central Asia" - ch. 14 and 15                                                 |
| GoNotoSouthEastAsia.ttf    | "Southeast Asia" - ch. 16 and "Indonesia and the Philippines" - ch 17                    |
| GoNotoCJKCore.ttf          | [UnihanCore2020][3] subset of CJK (~20K ideographs). Use [Noto CJK][2] for full coverage |
| GoNotoEastAsia.ttf         | "East Asia" - ch 18. everything other than Han (CJK)                                     |

Each of the above fonts includes LGC (Latin-Greek-Cyrillic) as default, same coverage as `Noto Sans
Regular`. Each one also includes Noto Sans Math, Noto Music, Noto Sans Symbols and Noto Sans Symbols
2 to give you bonus coverage of beautiful notations, symbols and emoji :)

### Go Noto South Asia

Following are included: Bengali, Chakma, Devanagari (Hindi, Marathi, Nepali, etc), Gujarati, Gunjala
Gondi, Kannada, Lepcha, Limbu, Malayalam, Masaram Gondi, Meetei Mayek, Mro, Nag Mundari, Newa, Ol
Chiki, Oriya, Punjabi (Gurmukhi), Saurashtra, Sinhala, Tamil, Tangsa, Telugu, Thaana, Tibetan, Toto,
Wancho, Warang Citi.

Urdu (Noto Naskh Arabic), though not written in an Indic script and not part of "South Asia"
chapters in the Unicode spec, is included for practical reasons. Noto Nastaliq Urdu would be more
appropriate but it is too big to fit in the merged font.

### Go Noto Asia Historical

Following are included: Ahom, Bhaiksuki, Brahmi, Dives Akuru, Dogra, Grantha, Indic Siyaq Numbers,
Kaithi, Kharoshthi, Khojki, Khudawadi, Mahajani, Makasar, Marchen, Modi, Multani, Old Sogdian, Old
Turkic, Old Uyghur, Ottoman Siyaq Numbers, Phags-Pa, Sharada, Siddham, Sogdian, Sora Sompeng,
Soyombo, Syloti Nagri, Takri, Tirhuta, Zanabazar Square.

### Go Noto South East Asia

Following are included: Balinese, Batak, Buginese, Buhid, Cham, Hanifi Rohingya, Hanunoo, Javanese,
Kayah Li, Kawi, Khmer, Lao, Makasar, Myanmar, New Tai Lue, Nyiakeng Puache Hmong, Pahawh Hmong, Pau
Cin Hau, Rejang, Sundanese, Tagalog, Tagbanwa, Tai Le, Tai Tham, Tai Viet, Thai.

### Go Noto Europe Americas

Everything covered by NotoSans (Latin-Greek-Cyrillic etc.) plus Anatolian Hieroglyphics, Armenian,
Canadian Aboriginal, Carian, Caucasian Albanian, Cherokee, Coptic, Cypriot, Deseret, Duployan,
Elbasan, Georgian, Glagolitic, Gothic, Linear A, Linear B, Lycian, Lydian, Mayan Numerals, Nyiakeng
Puachue Hmong, Ogham, Old Hungarian, Old Italic, Old Permic, Osage, Runic, Shavian, Sutton Sign
Writing, Vithkuqi.

### Go Noto Africa Middle East

The following are included: Adlam, Anatolian Hieroglyphics, Arabic (Naskh-style), Avestan, Bamum,
Bassa Vah, Chorasmian, Cuneiform, Egyptian, Elymaic, Ethiopic, Hatran, Hebrew, Imperial Aramaic, Inscriptional
Pahlavi, Inscriptional Parthian, Mandaic, Manichaean, Meroitic, Nabataean, Old North Arabian, Old
Persian, Old South Arabian, Palmyrene, Phoenician, Psalter Pahlavi, Samaritan, Syriac, Ugaritic,
Yezidi.

### Go Noto East Asia

Khitan Small Script, Lisu, Marchen, Miao, Mongolian, Nüshu, Tangut, Tibetan, Yi, etc. excluding
Han/CJK (Chinese-Japanese-Korean). Vertical text writing is not supported.

### Go Noto CJK Core

[Unihan IICore][1] is a minimal, region-agnostic subset of Han/CJK specified in 2005 for
memory-constrained systems. It standardizes about 9800 codepoints, covering basic use cases of
Chinese (Traditional, Simplified), Japanese and Korean. Recently [Unihan Core 2020][3] superseded
and expanded the minimal subset to about 20000 codepoints. Go Noto CJK Core includes a superset of
codepoints from both of these subsets.

The GoNotoCJKCore.ttf includes "locl" layout feature, so it can display Japanese or Korean glyphs
just by switching the language in your editor/word processor/web browser etc. Hiragana, Katakana and
Hangul are included.

Why use this instead of the upstream [Noto CJK][2] Fonts? Because our font also contains Noto Sans
Math, Noto Music, Noto Sans Symbols, Noto Sans Symbols 2, plus everything in Noto Sans (Regular) --
so you can have emojis, mathematical notation, musical symbols and Latin-Greek-Cyrillic in a single
font. But all the upstream Noto CJK Fonts have maxed out 65K glyphs, so they don't have space
anymore for glyphs additions.

The only limitation is that Go Noto CJK Core does not support vertical text writing.


## Font Statistics

Font statistics are collected in tsv format (tab separated value) by the CI pipeline in every run
and can be downloaded in build Artifacts.

Statistics below correspond to release v5.1.

| Go Noto Font               | Unicode blocks | Characters | Glyphs |
|----------------------------|---------------:|-----------:|-------:|
| GoNotoCurrent.ttf          |            197 |      32804 |  61207 |
| GoNotoAncient.ttf          |            178 |      24556 |  32971 |
| GoNotoEuropeAmericas.ttf   |            120 |      13391 |  53393 |
| GoNotoAfricaMiddleEast.ttf |            128 |      16055 |  20429 |
| GoNotoSouthAsia.ttf        |            119 |      11632 |  21184 |
| GoNotoAsiaHistorical.ttf   |            124 |      11100 |  18457 |
| GoNotoSouthEastAsia.ttf    |            112 |      10813 |  15044 |
| GoNotoEastAsia.ttf         |            109 |      18710 |  24525 |
| GoNotoCJKCore.ttf          |            107 |      41132 |  61658 |

NotoSansSignWriting alone contributes about 37900 glyphs to GoNotoEuropeAmericas.ttf.

Note that each of the above include statistics of:

| Upstream font       | Unicode blocks | Characters | Glyphs |
|---------------------|---------------:|-----------:|-------:|
| Noto Sans           |             37 |       2840 |   3748 |
| Noto Sans Math      |             22 |       2472 |   2655 |
| Noto Music          |              7 |        561 |    581 |
| Noto Sans Symbols   |             15 |        840 |   1218 |
| Noto Sans Symbols 2 |             37 |       2655 |   2674 |
| Total               |            111 |       9368 |  10876 |

## Caveats

1. You might have to increase line spacing or line margins in your application to avoid some
   characters appearing "clipped". This is because many Asian scripts stack letters vertically
   (e.g. Indic scripts, Thai, Balinese etc.) but the line metrics of the merged font are
   optimized for LGC.
2. Tibetan has limited glyphs, otherwise GSUB table gets "overflow"ed. Only the most frequently
   occuring "subjoined consonants" are included. Those characters are displayed ok, but just that
   the glyphs appear to be "pushed up" compared to their neighbours.
3. Vertical text layout is not supported for CJK, Dogra, Mongolian, Nandinagari, Nüshu and Tangut,
   even though the upstream Noto Fonts has the support because fonttools does not support merging
   with `vmtx`/`vhea`.
4. Go Noto Current has limited support for CJK -- it offers the full Unihan IICore subset plus more
   glyphs, so it should work ok-ish for daily use but there can be missing glyphs. As before,
   vertical text writing is not supported with this font.
5. Duployan has limited glyphs, also to avoid GSUB overflow. Cursive connections, contextual forms,
   and overlap trees are disabled. Shading and combining marks still work.

## License

In the spirit of _loka-saṃgraha_, the scripts distributed in this git repository (the "Software")
are dedicated to the public domain as per "The Unlicense". See UNLICENSE.txt.

However, the fonts generated by using the Software are licensed under the SIL Open Font License,
Version 1.1, as required by the upstream Noto Fonts Project.

### Others

FontTools package comes with nice utilities `ttx` (ttf to xml and back), `pyftsubset` (create font
with subset of given font) and `pyftmerge` (merging fonts, the workhorse of this repo).

`libharfbuzz-bin` offers CLI utilities `hb-view` and `hb-shape` which are useful for visualising
rendered characters.

`otfinfo` gives useful info about glyphs, codepoints, scripts and more.

[1]: https://wikipedia.org/wiki/International_Ideographs_Core
[2]: https://github.com/googlefonts/noto-cjk/
[3]: https://unicode.org/charts/unihan.html
