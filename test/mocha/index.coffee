chai = require 'chai'
expect = chai.expect

Report = require '../../src/index'

describe "init", ->

  it "should allow to initialize new object", ->
    report = new Report()
    expect(report).to.be.instanceOf Report
