### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe.only "visual qr", ->
  @timeout 5000

  it "should create simple code", (cb) ->
    report = new Report()
    report.qr "http://alinex.de"
    test.report 'qr-simple', report, """

      $$$ qr
      http://alinex.de
      $$$

      """, null, cb

  it "should create extended code", (cb) ->
    report = new Report()
    report.qr
      content: 'http://alinex.github.io'
      padding: 1
      width: 600
      height: 600
      color: '#ff0000'
      background: '#ffffff'
      ecl: 'M'
    test.report 'qr-extended', report, """

      $$$ qr
      content: 'http://alinex.github.io'
      padding: 1
      width: 600
      height: 600
      color: '#ff0000'
      background: '#ffffff'
      ecl: M
      $$$

      """, null, cb
