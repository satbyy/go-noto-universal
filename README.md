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

| Regional font              | Coverage                                                                             |
|----------------------------|--------------------------------------------------------------------------------------|
| GoNotoSouthAsia.ttf        |                                                                                      |
| GoNotoSouthEastAsia.ttf    |                                                                                      |
| GoNotoEuropeAmericas.ttf   |                                                                                      |
| GoNotoAfricaMiddleEast.ttf |                                                                                      |
| GoNotoAsiaHistorical.ttf   |                                                                                      |
| GoNotoEastAsia.ttf         |                                                                                      |
| GoNotoCJK.ttf              | [Noto CJK](https://github.com/googlefonts/noto-cjk/blob/main/Sans/README-formats.md) |
|                            |                                                                                      |


