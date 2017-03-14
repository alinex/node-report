### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "definition", ->

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

    it "should definition", (cb) ->
      # create report
      report = new Report()
      report.definition
        'Term 1': 'Definition 1'
        'Term 2': 'Definition 2'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 2'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 2'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: 'Term 1\n  : Definition 1\n\nTerm 2\n  : Definition 2'}
        {format: 'text', text: 'Term 1\n  : Definition 1\n\nTerm 2\n  : Definition 2'}
        {format: 'html', text: 'dl>\n<dt>Term 1</dt>\n<dd><p>Definition 1</p>\n</dd>\n<dt>Term 2</dt>\n<dd><p>Definition 2</p>\n</dd>\n</dl>'}
      ], cb

    it "should definition (short name)", (cb) ->
      # create report
      report = new Report()
      report.dl
        'Term 1': 'Definition 1'
        'Term 2': 'Definition 2'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 2'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 2'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: 'Term 1\n  : Definition 1\n\nTerm 2\n  : Definition 2'}
        {format: 'text', text: 'Term 1\n  : Definition 1\n\nTerm 2\n  : Definition 2'}
        {format: 'html', text: 'dl>\n<dt>Term 1</dt>\n<dd><p>Definition 1</p>\n</dd>\n<dt>Term 2</dt>\n<dd><p>Definition 2</p>\n</dd>\n</dl>'}
      ], cb

    it "should work in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.dl true
      report.dt 'Term 1'
      report.dd 'Definition 1'
      report.dt 'Term 2'
      report.dd 'Definition 2'
      report.dl false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 2'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 2'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: 'Term 1\n  : Definition 1\n\nTerm 2\n  : Definition 2'}
        {format: 'text', text: 'Term 1\n  : Definition 1\n\nTerm 2\n  : Definition 2'}
        {format: 'html', text: 'dl>\n<dt>Term 1</dt>\n<dd><p>Definition 1</p>\n</dd>\n<dt>Term 2</dt>\n<dd><p>Definition 2</p>\n</dd>\n</dl>'}
      ], cb
