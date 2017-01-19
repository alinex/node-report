### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "blockquote", ->

#  it "should run first test", (cb) ->
#    test.markdown 'blockquote/multiple', """
#      > Manfred said:
#      >
#      > > Everything will work next week.
#      >
#      But we don't think so.
#    """, null, null, cb

  describe.only "examples", ->

    it "should make two blockquotes", (cb) ->
      test.markdown 'blockquote/multiple', """
        > Manfred said:
        >
        > > Everything will work next week.
        >
        But we don't think so.
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

    # http://spec.commonmark.org/0.27/#example-189s
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
