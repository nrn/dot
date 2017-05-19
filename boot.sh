#!/bin/bash

git clone https://github.com/VundleVim/Vundle.vim ./home/.vim/bundle/Vundle.vim
git clone https://github.com/isaacs/nave

NODE_GLOBAL="$HOME/node-global"
export PATH="$NODE_GLOBAL/bin:$PATH"
mkdir "$NODE_GLOBAL"

PREFIX="$NODE_GLOBAL" ./nave/nave.sh usemain latest

npm install
node install.js
vim +PluginInstall +qall
npm install --prefix="$NODE_GLOBAL" -g nave npm eslint js-beautify standard-format readme
