### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "list", ->

  it.only "should run first test", (cb) ->
    test.markdown 'list/bullet', """
      - write code
      - test it
    """, null, null, cb

  describe "examples", ->

    it "should make two blockquotes", (cb) ->
      test.markdown 'blockquote/multiple', """
        This is an example of two paragraphs in markdown style there the separation
        between them is done with an empty line.

        This follows the common definition of markdown.
      """, null, [
        {format: 'md'}
        {format: 'text'}
        {format: 'html'}
        {format: 'man'}
      ], cb

  describe "api", ->

    it "should create paragraph", (cb) ->
      # create report
      report = new Report()
      report.p 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'foo'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo/}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<p>foo</p>\n"}
        {format: 'man', text: "foo"}
      ], cb

  describe "markdown", ->

    # http://spec.commonmark.org/0.27/#example-180
    it "should work with single line paragraphs", (cb) ->
      test.markdown null, 'aaa\n\nbbb', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa'}}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
