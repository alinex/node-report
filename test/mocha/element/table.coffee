### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "table", ->

  describe.only "examples", ->

    it "should make two tables", (cb) ->
      test.markdown 'table/align', """
      | Left-aligned | Center-aligned | Right-aligned |
      | :---         |     :---:      |          ---: |
      | 1            | one            | eins          |
      | 2            | two            | zwei          |
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'console'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe "api", ->

    it "should create table", (cb) ->
      # create report
      report = new Report()
      report.table 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'table', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'table', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo/}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<p>foo</p>\n"}
        {format: 'man', text: "foo"}
      ], cb
