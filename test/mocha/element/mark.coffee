chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "mark", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'mark/simple', "That's ==marked== as success.", null, true, cb

  describe "api", ->

    it "should create mark in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.mark 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'mark', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'mark', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create mark in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.mark true
      report.text 'foo'
      report.mark false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'mark', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'mark', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail mark if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.mark 'code').to.throw Error
      cb()

    it "should do nothing without content in mark", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.mark()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
