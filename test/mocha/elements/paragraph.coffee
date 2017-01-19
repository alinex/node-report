### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "paragraph", ->

  describe "examples", ->

    it "should make two paragraphs", (cb) ->
      test.markdown 'paragraph/multiple', """
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
        {type: 'text', data: {text: 'foo'}}
        {type: 'text', data: {text: 'bar'}}
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
        {type: 'text', data: {text: 'foo'}}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bar'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', re: /foo\n\nbar/}
        {format: 'text', re: /foo\n\nbar/}
        {format: 'html', text: "<p>foo</p>\n<p>bar</p>\n"}
        {format: 'man', text: ".P\nfoo\n.P\nbar"}
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

    # http://spec.commonmark.org/0.27/#example-181
    it "should work with multiple lines in paragraph", (cb) ->
      test.markdown null, 'aaa\nbbb\n\nccc\nddd', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa bbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'ccc ddd'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-182
    it "should work with multiple blank lines in paragraph", (cb) ->
      test.markdown null, 'aaa\nbbb\n\nccc\nddd', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa bbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'ccc ddd'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-183
    it "should work with 1-3 leading spaces ignored", (cb) ->
      test.markdown null, '  aaa\n bbb', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa bbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-184
    it "should work with multiple leading spaces after the first line", (cb) ->
      test.markdown null, 'aaa\n             bbb\n                                       ccc', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa bbb ccc'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-185
    it "should work with first line indented 3 spaces", (cb) ->
      test.markdown null, '   aaa\nbbb', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa bbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-186
    it "should fail with 4 or more spaces", (cb) ->
      test.markdown null, '    aaa\nbbb', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', data: {text: 'aaa'}}
        {type: 'preformatted', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'bbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-187
    it "should work with line break if two or more spaces", (cb) ->
      test.markdown null, 'aaa     \nbbb     ', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa bbb '}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
