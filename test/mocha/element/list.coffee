### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "list", ->

#  it "should run first test", (cb) ->
#    test.markdown 'list/bullet', """
#      - write code
#      - test it
#    """, null, null, cb

  describe "examples", ->

    it "should make bullet list", (cb) ->
      test.markdown 'list/bullet', """
        Capital Cities:
        - Europe
          - Berlin
          - London
          - Paris
        - Africa
          - Tunis
          - Kairo
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe "api", ->

    it "should create bullet list", (cb) ->
      # create report
      report = new Report()
      report.list ['one', 'two', 'three'], 'bullet'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1}
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
        {format: 'text', re: /   - one\n   - two\n   - three/}
        {format: 'html', text: "<ul>\n<li><p>one</p></li>\n<li><p>two</p></li>\n<li><p>three</p></li>\n</ul>\n"}
      ], cb
