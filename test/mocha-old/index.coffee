chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

Report = require '../../src/index'

describe "base", ->

  describe "init", ->

    it "should allow to initialize new object", ->
      report = new Report()
      expect(report).to.be.instanceOf Report
