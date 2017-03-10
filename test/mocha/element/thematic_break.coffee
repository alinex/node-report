### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "thematic break", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'thematic_break/line', """
      The first part.

      ---

      The second part.
      """, null, true, cb

  describe "api", ->

    it "should create line", (cb) ->
      # create report
      report = new Report()
      report.thematic_break()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'thematic_break'}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /\*{3,}/}
        {format: 'text', re: /─{3,}/}
        {format: 'html', text: "<hr />\n"}
        {format: 'man', text: ".HR"}
      ], cb

    it "should create line (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.hr()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'thematic_break'}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /\*{3,}/}
        {format: 'text', re: /─{3,}/}
        {format: 'html', text: "<hr />\n"}
        {format: 'man', text: ".HR"}
      ], cb
