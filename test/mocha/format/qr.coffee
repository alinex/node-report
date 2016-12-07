### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe "visual qr", ->
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
      width: 500
      height: 500
      color: '#ff0000'
      background: '#ffffff'
      ecl: 'M'
    test.report 'qr-extended', report, """

      $$$ qr
      content: 'http://alinex.github.io'
      padding: 1
      width: 500
      height: 500
      color: '#ff0000'
      background: '#ffffff'
      ecl: M
      $$$

      """, null, cb

  it.only "should create test", (cb) ->
    report = new Report """
    Test __xxx__ Nr. 1
    """
#    report.qr "http://alinex.de"
    test.report '---', report, null, null, cb
