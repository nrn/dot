#!/usr/bin/node

var path = require('path')
  , fs = require('fs')
  , sh = require('shelljs')

var HOME = process.env.HOME

var OLD = path.join(HOME, 'old.dot')

function backup (file) {
  sh.mv(path.join(HOME, file), path.join(OLD, file))
  sym(file)
}

function sym (file) {
  fs.symlink(path.join(__dirname, file), path.join(HOME, file))
}

function main () {
  sh.mkdir(OLD)
  ;['.vimrc', '.gitconfig', '.vim' ]
    .forEach(backup)
}

main()
