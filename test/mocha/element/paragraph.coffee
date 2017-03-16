### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "paragraph", ->

  describe "examples", ->
    @timeout 30000

    it "should make two paragraphs", (cb) ->
      test.markdown 'paragraph/multiple', """
        This is an example of two paragraphs in markdown style there the separation
        between them is done with an empty line.

        This follows the common definition of markdown.
      """, null, true, cb

  describe "api", ->

    it "should create paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph 'foo'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo/}
        {format: 'text', re: /foo/}
        {format: 'html', text: "<p>foo</p>\n"}
        {format: 'man', text: "foo"}
      ], cb

    it "should create in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.p true
      report.text 'foo'
      report.text 'bar'
      report.p false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foobar/}
        {format: 'text', re: /foobar/}
        {format: 'html', text: "<p>foobar</p>\n"}
        {format: 'man', text: "foobar"}
      ], cb

    it "should work with multiple paragraphs", (cb) ->
      # create report
      report = new Report()
      report.p 'foo'
      report.p 'bar'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\n\nbar/}
        {format: 'text', re: /foo\n\nbar/}
        {format: 'html', text: "<p>foo</p>\n<p>bar</p>\n"}
        {format: 'man', text: ".P\nfoo\n.P\nbar"}
      ], cb

  describe "format", ->

    it "should create paragraph", (cb) ->
      # check it
      test.markdown null, """
        This is a very long line. It has to be broken into multiple lines for plain text output or to display on console. It should be broken into two lines.
        """, null, [
        {format: 'text', re: /\n/}
      ], cb

    it "should create paragraph within blockquote", (cb) ->
      # check it
      test.markdown null, """
        > > > > This is a very long line. It has to be broken into multiple lines for plain text output or to display on console. It should be broken into two lines.
        """, null, [
        {format: 'text', re: /\n/}
      ], cb
