### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe.only "definition", ->

  describe "examples", ->
    @timeout 30000

    it "should make list", (cb) ->
      test.markdown 'list/definition', """
        Term 1
          : Definition 1

        Term 2
          : Definition 2
        """, null, true, cb

  describe "api", ->

    it "should create list", (cb) ->
      # create report
      report = new Report()
      report.list ['one', 'two', 'three'], 'bullet'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'three'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /   - one\n   - two\n   - three/}
        {format: 'text', re: /   • one\n   • two\n   • three/}
        {format: 'html', text: "<ul>\n<li>one</li>\n<li>two</li>\n<li>three</li>\n</ul>\n"}
      ], cb
