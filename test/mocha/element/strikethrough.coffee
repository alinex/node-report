chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "strikethrough", ->

  describe "examples", ->

    it "should make examples", (cb) ->
      test.markdown 'strikethrough/simple', "That's a ~~big~~ success.", null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
        {format: 'adoc'}
      ], cb

  describe "api", ->

    it "should create strikethrough in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.strikethrough 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strikethrough', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strikethrough', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create strikethrough in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.strikethrough true
      report.text 'foo'
      report.strikethrough false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strikethrough', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strikethrough', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create strikethrough in paragraph (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.del 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'strikethrough', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'strikethrough', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail strikethrough if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.strikethrough 'code').to.throw Error
      cb()

    it "should do nothing without content in strikethrough", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.strikethrough()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
