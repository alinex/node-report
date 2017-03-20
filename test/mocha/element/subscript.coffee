chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "subscript", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'subscript/simple', "You need H~2~O for this experiment.", null, true, cb

  describe "api", ->

    it "should create subscript in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.subscript 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'subscript', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'subscript', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create subscript in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.subscript true
      report.text 'foo'
      report.subscript false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'subscript', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'subscript', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create subscript in paragraph (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.sub 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'subscript', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'subscript', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail subscript if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.subscript 'code').to.throw Error
      cb()

    it "should do nothing without content in subscript", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.subscript()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
