#!/bin/bash

THEME_PATH="_vendor/github.com/mitodl/ocw-course-hugo-theme"
PDFJS_PATH="pdfjs"

# init or update the pdfjs submodule and install our local dependencies
git submodule update --init --recursive
yarn install

# empty the _vendor folder, update theme module
# and redeploy to _vendor
rm -rf _vendor
hugo mod get -u
hugo mod vendor

# install and build pdfjs
npm install --prefix $PDFJS_PATH
npm run gulp:pdfjs

# install and build ocw-course-hugo-theme
yarn install --cwd $THEME_PATH
npm run build:webpack --prefix $THEME_PATH

# copy artifacts where they belong
mkdir -p static/pdfjs
cp -r pdfjs/build/generic/* static/pdfjs
cp -r $THEME_PATH/dist/* $THEME_PATH/static