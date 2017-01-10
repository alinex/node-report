### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe.only "preformatted", ->

  describe "examples", ->

    it "should make preformatted text", (cb) ->
      test.markdown 'preformatted/data', """
        Preformatted Text:

            This line is preformatted!
                 ^^^^
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

    # http://spec.commonmark.org/0.27/#example-181
    it "should work with multiple lines in paragraph", (cb) ->
      test.markdown null, 'aaa\nbbb\n\nccc\nddd', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa\nbbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'ccc\nddd'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-182
    it "should work with multiple blank lines in paragraph", (cb) ->
      test.markdown null, 'aaa\nbbb\n\nccc\nddd', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa\nbbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'ccc\nddd'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-183
    it "should work with 1-3 leading spaces ignored", (cb) ->
      test.markdown null, '  aaa\n bbb', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa\nbbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-184
    it "should work with multiple leading spaces after the first line", (cb) ->
      test.markdown null, 'aaa\n             bbb\n                                       ccc', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa\nbbb\nccc'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-185
    it "should work with first line indented 3 spaces", (cb) ->
      test.markdown null, '   aaa\nbbb', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', data: {text: 'aaa\nbbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-186
    it "should fail with 4 or more spaces", (cb) ->
      test.markdown null, '    aaa\nbbb', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', data: {text: 'aaa'}}
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
        {type: 'text', data: {text: 'aaa\nbbb'}}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
