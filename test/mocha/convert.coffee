chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug')('test:instance')
Report = require '../../src/index'

equal = (a, b) ->
  debug "result", a
#  console.log util.inspect a
#  console.log util.inspect b
  expect(a, 'result').to.equal b

describe.only "output", ->

  describe "console", ->

    it "should transform bold", ->
      report = new Report
        source: 'My **Test** is OK'
      equal report.toString().trim(), "My **Test** is OK"
      equal report.toConsole().trim(), "My \u001b[1mTest\u001b[22m is OK"

    it "special", ->
      report = new Report()
      report.h1 "Heading"
      report.code '                ###   #                     #   ###           #   ###\n                ###  ###                   ###  ###          ###  ###\n                ###   #                     #   ###           #   ###\n                ###                             ###               ###\n   ##      ########  ###  ###         ###  ###  ########     ###  ########\n  ####   ###    ###  ###   ###       ###   ###  ###    ###   ###  ###    ###\n   ##   ###     ###  ###    ###     ###    ###  ###     ###  ###  ###     ###\n        ###     ###  ###     ###   ###     ###  ###     ###  ###  ###     ###\n   ##   ###     ###  ###      ### ###      ###  ###     ###  ###  ###     ###\n  ####   ###    ###  ###       #####       ###  ###    ###   ###  ###    ###\n   ##      ########  ###        ###        ###  ########     ###  ########\n\n  ___________________________________________________________________________\n\n                          S C R I P T   C O N S O L E\n  ___________________________________________________________________________\n\nInitializing...\nBUILDER\n\nSearching for magazines...\nNichts gefunden!\n\nDone.\n\n╔═════════════════════════════════════════════╗\n║Keine ePaper/eMagazine für import gefunden!  ║\n╚═════════════════════════════════════════════╝\n\nGoodbye\n', 'text'
      report.p "Further text...."
      console.log report.toString()
      console.log report.toConsole()
#      equal report.toString().trim(), "My **Test** is OK"
#      equal report.toConsole().trim(), "My \u001b[1mTest\u001b[22m is OK"
