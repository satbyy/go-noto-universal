#!/bin/bash -e

[[ -z "$VIRTUAL_ENV" ]] && echo "Refusing to run outside of venv. See README.md." && exit 1

python3 -m pip install fonttools

if [[ ! -d nototools ]]; then
    git clone --depth 1 https://github.com/googlefonts/nototools
else
    echo "Re-using existing clone of nototools."
fi

# Patch merge_fonts.py to be callable by external script
cd nototools/
if ! git apply --reverse --check ../merge_fonts.patch 2> /dev/null; then
    echo "applying patch"
    git apply ../merge_fonts.patch
else
    echo "patch already applied"
fi
cd "$OLDPWD"

# create tibetan subset so that GSUB is not overflow'ed.
subset_tibetan() {
    mkdir -p cached_fonts/ && cd cached_fonts/
    if [[ ! -e NotoSerifTibetanSubset-Regular.ttf ]]; then
        if [[ ! -e NotoSerifTibetan-Regular.ttf ]]; then
            wget https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/NotoSerifTibetan/NotoSerifTibetan-Regular.ttf
        fi
        echo "Creating a smaller subset of Tibetan glyphs..."
        $VIRTUAL_ENV/bin/pyftsubset NotoSerifTibetan-Regular.ttf --output-file=NotoSerifTibetanSubset-Regular.ttf \
                   --unicodes=U+0F00-0F8C,U+0FBA-0FDA
    fi
    cd "$OLDPWD"
}

subset_tibetan

declare -a fonts=(
    GoNotoSouthAsia.ttf
    GoNotoAsiaHistorical.ttf
    GoNotoSouthEastAsia.ttf
    GoNotoEastAsia.ttf
    GoNotoEuropeAmericas.ttf
    GoNotoAfricaMiddleEast.ttf
)

for font in "${fonts[@]}"; do
    if [[ -e "$font" ]]; then
        echo "Not overwriting existing font $font"
        continue
    fi
    printf "Generating font $font. Current time: $(date)\n"
    mkdir -p cached_fonts
    time PYTHONPATH="nototools/nototools" python3 generate.py -o "$font" -d cached_fonts
done
