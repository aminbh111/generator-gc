#!/bin/bash
set -ev
#-------------------------------------------------------------------------------
# Force no insight
#-------------------------------------------------------------------------------
mkdir -p "$HOME"/.config/configstore/
mv "$GREENCODE_TRAVIS"/configstore/*.json "$HOME"/.config/configstore/

#-------------------------------------------------------------------------------
# Generate the project with yo greencode
#-------------------------------------------------------------------------------
mv -f "$GREENCODE_SAMPLES"/"$GREENCODE" "$HOME"/
cd "$HOME"/"$GREENCODE"

rm -Rf "$HOME"/"$GREENCODE"/node_modules/.bin/*grunt*
rm -Rf "$HOME"/"$GREENCODE"/node_modules/*grunt*

npm link generator-greencode
yo greencode --force --no-insight
ls -al "$HOME"/"$GREENCODE"
ls -al "$HOME"/"$GREENCODE"/node_modules/
ls -al "$HOME"/"$GREENCODE"/node_modules/generator-greencode/
ls -al "$HOME"/"$GREENCODE"/node_modules/generator-greencode/generators/
ls -al "$HOME"/"$GREENCODE"/node_modules/generator-greencode/generators/entity/
