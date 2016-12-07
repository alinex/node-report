chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

chalk = require 'chalk'
debug = require('debug')('test:instance')
Report = require '../../src/index'
test = require './test'

chalk.enabled = true

equal = (a, b) ->
  debug "result", a
#  console.log util.inspect a
#  console.log util.inspect b
  expect(a, 'result').to.equal b

describe "output", ->

  describe.only "console", ->

    it "should transform bold", ->
      report = new Report
        source: 'My **Test** is OK'
      equal report.toString().trim(), "My **Test** is OK"
      equal report.toConsole().trim(), "My \u001b[1mTest\u001b[22m is OK"

    it "should keep console parts", ->
      report = new Report
        source: 'My **Test** is OK
        <!-- begin console -->only **on** console<!-- end console -->'
      equal report.toConsole().trim(), "My \u001b[1mTest\u001b[22m is OK
      only \u001b[1mon\u001b[22m console"

    it "should keep no-html parts", ->
      report = new Report
        source: 'My **Test** is OK
        <!-- begin no-html -->only **on** console<!-- end no-html -->'
      equal report.toConsole().trim(), "My \u001b[1mTest\u001b[22m is OK
      only \u001b[1mon\u001b[22m console"

    it "should remove html parts", ->
      report = new Report
        source: 'My **Test** is OK
        <!-- begin html -->not **on** console<!-- end html -->'
      equal report.toConsole().trim(), "My \u001b[1mTest\u001b[22m is OK"

    it "should remove no-console parts", ->
      report = new Report
        source: 'My **Test** is OK
        <!-- begin no-console -->not **on** console<!-- end no-console -->'
      equal report.toConsole().trim(), "My \u001b[1mTest\u001b[22m is OK"

#    it "special", ->
#      report = new Report()
#      report.h1 "Heading"
#      report.code '                ###   #                     #   ###           #   ###\n                ###  ###                   ###  ###          ###  ###\n                ###   #                     #   ###           #   ###\n                ###                             ###               ###\n   ##      ########  ###  ###         ###  ###  ########     ###  ########\n  ####   ###    ###  ###   ###       ###   ###  ###    ###   ###  ###    ###\n   ##   ###     ###  ###    ###     ###    ###  ###     ###  ###  ###     ###\n        ###     ###  ###     ###   ###     ###  ###     ###  ###  ###     ###\n   ##   ###     ###  ###      ### ###      ###  ###     ###  ###  ###     ###\n  ####   ###    ###  ###       #####       ###  ###    ###   ###  ###    ###\n   ##      ########  ###        ###        ###  ########     ###  ########\n\n  ___________________________________________________________________________\n\n                          S C R I P T   C O N S O L E\n  ___________________________________________________________________________\n\nInitializing...\nBUILDER\n\nSearching for magazines...\nNichts gefunden!\n\nDone.\n\n╔═════════════════════════════════════════════╗\n║Keine ePaper/eMagazine für import gefunden!  ║\n╚═════════════════════════════════════════════╝\n\nGoodbye\n', 'text'
#      report.p "Further text...."
#      console.log report.toString()
#      console.log report.toConsole()

#      equal report.toString().trim(), "My **Test** is OK"
#      equal report.toConsole().trim(), "My \u001b[1mTest\u001b[22m is OK"
