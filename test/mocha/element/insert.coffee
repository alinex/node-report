chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "insert", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'insert/simple', "That's a ++big++ success.", null, true, cb

  describe "api", ->

    it "should create insert in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.insert 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'insert', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'insert', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create insert in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.insert true
      report.text 'foo'
      report.insert false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'insert', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'insert', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create insert in paragraph (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.ins 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'insert', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'insert', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail insert if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.insert 'code').to.throw Error
      cb()

    it "should do nothing without content in insert", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.insert()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
