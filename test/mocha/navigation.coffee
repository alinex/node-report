chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

Report = require '../../src'
before (cb) -> Report.init cb


test = (report, pos, data) ->
  expect(report.tokens.pos).to.equal pos
  for k, v of data
#    console.log k, report.tokens
    expect(report.tokens.token[k], "data.#{k}").to.deep.equal v

describe "navigation", ->

  report = null
  before ->
    report = new Report()
    report.p 'foo'
    report.q 'bar'
    report.p 'baz'

  describe "position", ->

    it "should jump to top", ->
      report.top()
      test report, 1,
        type: 'document'
        nesting: 1

    it "should fail to jump further back", ->
      report.prev()
      test report, 1,
        type: 'document'
        nesting: 1

    it "should jump to next element", ->
      report.next()
      test report, 2,
        type: 'paragraph'
        nesting: 1

    it "should jump to bottom", ->
      report.bottom()
      test report, 13,
        type: 'document'
        nesting: -1

    it "should fail to jump further on", ->
      report.next()
      test report, 13,
        type: 'document'
        nesting: -1

    it "should jump to previous element", ->
      report.prev()
      test report, 12,
        type: 'paragraph'
        nesting: -1

    it "should jump to start of element", ->
      report.start()
      test report, 10,
        type: 'paragraph'
        nesting: 1

    it "should jump to end of element", ->
      report.end()
      test report, 12,
        type: 'paragraph'
        nesting: -1

  describe "filter", ->

    it "should jump to first blockquote", ->
      report.top()
      report.next {type: 'blockquote'}
      test report, 5,
        type: 'blockquote'
        nesting: 1

    it "should jump to last blockquote open", ->
      report.bottom()
      report.prev {type: 'blockquote', nesting: 1}
      test report, 5,
        type: 'blockquote'
        nesting: 1
