chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
async = require 'alinex-async'

debug = require('debug')('test:instance')
Report = require '../../src/index'

equal = (a, b) ->
  debug "result", a
#  console.log util.inspect a
#  console.log util.inspect b
  expect(a, 'result').to.equal b

describe "console", ->

  report = new Report()

  it "should transform bold", ->
    report.p 'My **Test** is OK'
    equal report.toString().trim(), "My **Test** is OK"
    equal report.toConsole().trim(), "My \u001b[1mTest\u001b[22m is OK"
