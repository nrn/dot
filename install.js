#!/usr/bin/env node

var path = require('path')
  , fs = require('fs')
  , sh = require('shelljs')
  , HOME = process.env.HOME
  , OLD = path.join(HOME, 'old.dot')

function backup (file) {
  sh.mv(path.join(HOME, file), path.join(OLD, file))
  sym(file)
}

function sym (file) {
  fs.symlink(path.join(__dirname, file), path.join(HOME, file))
}

function main () {
  sh.mkdir(OLD)
  sh.exec('git submodule init', function (code, output) {
    console.log(output)
    sh.exec('git submodule update', {async: true})
  })
  ;['.vimrc', '.gitconfig', '.vim', '.bash_aliases', '.fonts' ]
    .forEach(backup)


main()
