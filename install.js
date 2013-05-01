#!/usr/bin/env node

var path = require('path')
  , fs = require('fs')
  , sh = require('shelljs')
  , HOME = process.env.HOME
  , OLD = path.join(HOME, 'old.dot')
  , BASHRC = path.join(HOME, '.bashrc')

sh.mkdir(OLD)

sh.ls('-A', 'home').forEach(backup)

sh.grep('.bash_aliases', BASHRC) || fs.appendFileSync(BASHRC, '\n. ~/.bash_aliases\n')

function backup (file) {
  sh.mv(path.join(HOME, file), path.join(OLD, file))
  sym(file)
}

function sym (file) {
  fs.symlinkSync(path.join(__dirname, 'home', file), path.join(HOME, file))
}

