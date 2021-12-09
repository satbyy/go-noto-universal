#!/bin/bash -e

[[ -z "$VIRTUAL_ENV" ]] && echo "Refusing to run outside of venv. See README.md" && exit 1

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
cd -

declare -a fonts=(
    GoNotoSouthAsia.ttf
    GoNotoAsiaHistorical.ttf
    GoNotoSouthEastAsia.ttf
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
