var execSync = require('child_process').execSync
var exit = 0
execSync("git diff --staged --diff-filter=ACMTUXB --name-only -- '*.js'", { encoding: 'utf8' })
  .split('\n')
  .forEach(function (name) {
    if (name) {
      try {
        execSync(`git show :${name} | eslint --stdin --stdin-filename=${name}`, { encoding: 'utf8' })
      } catch (e) {
        exit = 1
      }
    }
  })

  process.exit(exit)

