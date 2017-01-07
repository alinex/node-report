### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "char_style", ->

  describe "examples", ->

    it "should make examples", (cb) ->
      test.markdown 'char_style/formats', """
        `typewriter`
        **bold**
        _italic_
        ^superscript^
        ~subscript~
        ~~strikethrough~~
        ==marked==
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe "api", ->

    it "should create typewriter", (cb) ->
      # create report
      report = new Report()
      report.tt 'test'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'typewriter', nesting: 1}
        {type: 'text', data: {text: 'test'}}
        {type: 'typewriter', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /`test`/}
        {format: 'text', re: /`test`/}
        {format: 'html', text: "<code>test</code>\n"}
        {format: 'man', text: "\\fBtest\\fP"}
      ], cb

  describe "markdown", ->

    # http://spec.commonmark.org/0.27/#example-328
    it "should work with * for emphasis", (cb) ->
      test.markdown null, '*foo bar*', [
        {type: 'document', nesting: 1}
        {type: 'typewriter', nesting: 1}
        {type: 'text', data: {text: 'test'}}
        {type: 'typewriter', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
