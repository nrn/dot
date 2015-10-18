#!/bin/bash

git clone https://github.com/VundleVim/Vundle.vim ./home/.vim/bundle/Vundle.vim
git clone https://github.com/isaacs/nave

if [ "x$(which node || true)" == "x" ]; then
  ./nave/nave.sh usemain latest
fi

npm install
node install.js
npm install -g nave npm eslint
