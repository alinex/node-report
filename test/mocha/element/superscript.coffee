chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "superscript", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'superscript/simple', "This ground measures 328m^2^.", null, true, cb

  describe "api", ->

    it "should create superscript in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.superscript 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'superscript', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'superscript', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create superscript in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.superscript true
      report.text 'foo'
      report.superscript false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'superscript', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'superscript', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create superscript in paragraph (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.sup 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'superscript', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'superscript', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail superscript if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.superscript 'code').to.throw Error
      cb()

    it "should do nothing without content in superscript", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.superscript()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
