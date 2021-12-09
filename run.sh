#!/bin/bash -e

[[ -z "$VIRTUAL_ENV" ]] && echo "Refusing to run outside of venv. See README.md" && exit 1

python3 -m pip install fonttools

if [[ ! -d nototools ]]; then
    git clone --depth 1 https://github.com/googlefonts/nototools
else
    echo "Re-using existing clone of nototools."
fi

# Patch merge_fonts.py to be callable by external script
sed -e 's/from nototools.substitute_linemetrics/from substitute_linemetrics/g' \
    -e 's/build_valid_filenames(directory=args.directory)/build_valid_filenames(directory=args.directory, files=files)/g' \
    -i nototools/nototools/merge_fonts.py

declare -a fonts=(GoNotoSouthAsia.ttf
                  GoNotoSouthEastAsia.ttf)

for font in "${fonts[@]}"; do
    if [[ -e "$font" ]]; then
        echo "Not overwriting existing font $font"
        continue
    fi
    printf "Generating font $font.\n"
    mkdir -p cached_fonts
    PYTHONPATH="nototools/nototools" python3 generate.py -o "$font" -d cached_fonts
done
