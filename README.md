# Go Noto Universal

Noto fonts go universal! Download Noto fonts combined to suit your region (South Asia, SE Asia, East
Asia, Africa-MiddleEast, Europe-Americas).

This software combines/merges multiple [Noto Fonts](https://github.com/googlefonts/noto-fonts) to a
single, region-specific font.

## Download

If you simply want to _use_ the fonts, go to [Releases
page](https://github.com/satbyy/go-noto-universal/releases/) and download what you need.

Development builds are available from [GitHub
Actions](https://github.com/satbyy/go-noto-universal/actions) page. Click on any workflow with green
checkmark ✅ (pipeline passed) and under "Artifacts", download "GoNotoUniversal.zip" (login
required).

## Build

If you want to _build_ the fonts yourself, create a virtual environment (venv) and call `./run.sh`.

```
python3 -m venv venv_fonty
source venv_fonty/bin/activate
./run.sh
deactivate
```

Font generation can take 10 to 20 min, depending on your computer's capabilities.

`run.sh` is designed to be reentrant, so you can run it multiple times without altering the working
state of the repository or downloading stuff again and again.

Latest CI status:

[![CI](https://github.com/satbyy/go-noto-universal/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/satbyy/go-noto-universal/actions/workflows/main.yml)

## Dependencies

There is no dependency other than [`nototools`](https://github.com/googlefonts/nototools) and
[`fonttools`](https://github.com/fonttools/fonttools/). Both are automatically fetched and used.

## Coverage

Fonts are merged/combined as per the regions defined in the [Unicode Standard
(pdf)](https://www.unicode.org/versions/Unicode14.0.0/UnicodeStandard-14.0.pdf). Chapter numbers
below refer to that spec.

| Regional font              | Coverage                                                                                |
|----------------------------|-----------------------------------------------------------------------------------------|
| GoNotoEuropeAmericas.ttf   | "Europe" - ch. 7, 8 and "Americas" - ch 20                                              |
| GoNotoAfricaMiddleEast.ttf | "Middle East" - ch. 9, 10, 11 and "Africa" - ch. 19                                     |
| GoNotoSouthAsia.ttf        | "South and Central Asia" - ch. 12 and 13                                                |
| GoNotoAsiaHistorical.ttf   | "South and Central Asia" - ch. 14 and 15                                                |
| GoNotoSouthEastAsia.ttf    | "Southeast Asia" - ch. 16 and "Indonesia and Ocenia" - ch 17                            |
| GoNotoCJKCore2005.ttf      | [Unihan IICore][1] subset of CJK (~10K ideographs). Use [Noto CJK][2] for full coverage |
| GoNotoEastAsia.ttf         | "East Asia" - ch 18. everything other than Han (CJK)                                    |

Each of the above fonts includes LGC (Latin-Greek-Cyrillic) as default, same coverage as `Noto Sans
Regular`. Each one also includes Noto Sans Math, Noto Music, Noto Sans Symbols and Noto Sans Symbols
2 to give you bonus coverage of beautiful notations, symbols and emoji :)

### Go Noto South Asia

Following are included: Devanagari (Hindi, Marathi, Nepali, etc), Bengali, Punjabi (Gurmukhi),
Gujarati, Oriya, Tamil, Telugu, Kannada, Malayalam, Thaana, Sinhala, Newa, Tibetan, Limbu, Meetei
Mayek, Mro, Warang Citi, Ol Chiki, Chakma, Lepcha, Saurashtra, Masaram Gondi, Gunjala Gondi, Wancho.

Urdu (NotoNastaliq), though not written in an Indic script and not part of "South Asia" chapters in
the Unicode spec, is included for practical reasons. Mongolian is currently not included because of
issue with vmtx (vertical metrics). Noto fonts do not exist for Toto and Tangsa.

### Go Noto Asia Historical

Following are included: Brahmi, Kharoshthi, Bhaiksuki, Phags-Pa, Marchen, Zanabazar Square, Soyombo,
Old Turkic, Old Sogdian, Sogdian, Old Uyghur, Indic Siyaq Numbers, Syloti Nagri, Kaithi, Sharada,
Takri, Siddham, Mahajani, Khojki, Khudawadi, Multani, Tirhuta, Modi, Grantha, Ahom, Sora Sompeng,
Dogra.

Noto fonts do not exist for Dives Akuru and Ottoman Siyaq Numbers.

### Go Noto South East Asia

Following are included: Thai, Lao, Myanmar, Khmer, Tai Le, New Tai Lue, Tai Tham, Tai Viet, Kayah
Li, Cham, Pahawh Hmong, Nyiakeng Puache Hmong, Pau Cin Hau, Hanifi Rohingya, Tagalog, Hanunoo,
Buhid, Tagbanwa, Buginese, Balinese, Javanese, Sundanese, Rejang, Batak.

Noto fonts do not exist for Makasar.

### Go Noto Europe Americas

Everything covered by NotoSans (Latin-Greek-Cyrillic etc.) plus Armenian, Coptic, Cypriot, Georgian,
Deseret, Glagolitic, Osage, Old Italic, Runic, Duployan, Anatolian Hieroglyphics, Carian, Canadian
Aboriginal, Cherokee, Lycian, Lydian, Mayan Numerals, Nyiakeng Puachue Hmong, Old Hungarian, Gothic,
Elbasan, Caucasian Albanian, Vithkuqi, Ogham, Old Permic, Shavian, Sutton Sign Writing, Linear A and
Linear B.

### Go Noto Africa Middle East

The following are included: Arabic (Naskh-style), Adlam, Avestan, Bamum, Bassa Vah, Cuneiform,
Hebrew, Syriac, Samaritan, Mandaic, Yezidi, Old North Arabian, Old South Arabian, Phoenician,
Imperial Aramaic, Manichaean, Inscriptional Parthian, Inscriptional Pahlavi, Psalter Pahlavi,
Elymaic, Nabataean, Palmyrene, Hatran, Ugaritic, Old Persian, Egyptian, Meroitic, Anatolian
Hieroglyphics.

Noto fonts do not exist for Chorasmian.

### Go Noto East Asia

Tibetan, Lisu, Marchen, Miao, Yi, etc. excluding Han/CJK (Chinese-Japanese-Korean).

Mongolian, Nüshu and Tangut could not be included.

### Go Noto CJK Core 2005

[Unihan IICore][1] is a minimal, region-agnostic subset of Han/CJK specified in 2005 for
memory-constrained systems. It standardizes about 9800 codepoints, covering basic use cases of
Chinese (Traditional, Simplified), Japanese and Korean. Recently [Unihan Core
2020](https://unicode.org/charts/unihan.html) superseded and expanded the minimal subset to about
20000 codepoints.

The GoNotoCJKCore2005 includes "locl" features, so it can display Japanese or Korean glyphs just by
switching the language in your editor/word processor/web browser etc.

The generated font does _not_ contain Noto Sans Math, Noto Music, Noto Sans Symbols, Noto Sans
Symbols 2 because [fonttools does not
support](https://fonttools.readthedocs.io/en/latest/merge.html) merging fonts with CFF outlines
(which is the case for .otf). Converting .otf to .ttf still doesn't solve the problem because CJK
fonts have "vmtx" table, which is absent in other fonts, thus preventing `pyftmerge`.


## Font Statistics

Statistics below correspond to release v3.0.

| Regional font              | Code blocks | Codepoints | Glyphs |
|----------------------------|------------:|-----------:|-------:|
| GoNotoEuropeAmericas.ttf   |         120 |      13389 |  53570 |
| GoNotoAfricaMiddleEast.ttf |         128 |      16053 |  20329 |
| GoNotoSouthAsia.ttf        |         117 |      11502 |  21553 |
| GoNotoAsiaHistorical.ttf   |         122 |      11001 |  18248 |
| GoNotoSouthEastAsia.ttf    |         111 |      10786 |  15013 |
| GoNotoEastAsia.ttf         |         109 |      18708 |  25043 |
| GoNotoCJKCore2005.ttf      |          20 |      10338 |  20099 |

NotoSansSignWriting alone contributes about 37900 glyphs to GoNotoEuropeAmericas.ttf.

Note that each of the above (except CJKCore2005) include statistics of:

| Upstream font       | Code blocks | Codepoints | Glyphs |
|---------------------|------------:|-----------:|-------:|
| Noto Sans           |          37 |       2840 |   3317 |
| Noto Sans Math      |          22 |       2472 |   2655 |
| Noto Music          |           7 |        559 |    579 |
| Noto Sans Symbols   |          15 |        840 |   1218 |
| Noto Sans Symbols 2 |          37 |       2655 |   2674 |
| Total               |         111 |       8807 |   9864 |

## Caveats

1. You might have to increase line spacing or line margins in your application to avoid some
   characters appearing "clipped". This is because many Asian scripts stack letters vertically
   (e.g. Indic scripts, Thai, Balinese etc.) but the line metrics of the merged font are
   optimized for LGC.
2. Tibetan has limited glyphs, otherwise GSUB table gets "overflow"ed. Only the most frequently
   occuring "subjoined consonants" are included. Those characters are displayed ok, but just that
   the glyphs appear to be "pushed up" compared to their neighbours.
3. Vertical text layout is not supported for Dogra, Mongolian, Nandinagari, Nüshu and Tangut, even
   though the upstream Noto fonts has the support because fonttools does not support merging with
   `vmtx`/`vhea`.
4. GoNotoCJKCore2005 does not contain Noto Sans Math and Noto Sans Symbols because fonttools does
   not support merging CFF with others.

## License

In the spirit of _loka-saṃgraha_, the scripts distributed in this git repository (the "Software")
are dedicated to the public domain as per "The Unlicense". See UNLICENSE.txt.

However, the fonts generated by using the the Software are licensed under the SIL Open Font License,
Version 1.1, as required by the upstream Noto Fonts Project.

### Others

FontTools package comes with nice utilities `ttx` (ttf to xml and back), `pyftsubset` (create font
with subset of given font) and `pyftmerge` (merging fonts, basically same as this repo).

`otfinfo` gives useful info about glyphs, codepoints, scripts and more.

[1]: https://en.wikipedia.org/wiki/International_Ideographs_Core
[2]: https://github.com/googlefonts/noto-cjk/
