### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown preformatted", ->

  # http://spec.commonmark.org/0.27/#example-76
  it "should work with simple block", (cb) ->
    test.markdown null, '    a simple\n      indented code block', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'a simple\n  indented code block'}
      {type: 'preformatted', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-77
  # http://spec.commonmark.org/0.27/#example-78
  it "should fail because list takes precedence", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '- foo\n\n    bar', [
          {type: 'document', nesting: 1}
          {type: 'list', nesting: 1}
          {type: 'item', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'foo'}
          {type: 'paragraph', nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'bar'}
          {type: 'paragraph', nesting: -1}
          {type: 'item', nesting: -1}
          {type: 'list', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '1.  foo\n\n    - bar', [
          {type: 'document', nesting: 1}
          {type: 'list', nesting: 1}
          {type: 'item', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'foo'}
          {type: 'paragraph', nesting: -1}
          {type: 'list', nesting: 1}
          {type: 'item', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'bar'}
          {type: 'paragraph', nesting: -1}
          {type: 'item', nesting: -1}
          {type: 'list', nesting: -1}
          {type: 'item', nesting: -1}
          {type: 'list', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-79
  it "should work with contents not parsed", (cb) ->
    test.markdown null, '    <a/>\n    *hi*\n    - one', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: '<a/>\n*hi*\n- one'}
      {type: 'preformatted', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-80
  it "should work with multiple chunks", (cb) ->
    test.markdown null, '    chunk1\n    chunk2\n  \n \n \n    chunk3', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'chunk1\nchunk2\n\n\n\nchunk3'}
      {type: 'preformatted', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-81
  it "should keep spaces beyond the indention", (cb) ->
    test.markdown null, '    chunk1\n      \n      chunk2', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'chunk1\n  \n  chunk2'}
      {type: 'preformatted', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-82
  it "should fail in paragraph", (cb) ->
    test.markdown null, 'Foo\n    bar', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'Foo'}
      {type: 'softbreak'}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-83
  it "should end code block if too less indention", (cb) ->
    test.markdown null, '    foo\nbar', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'preformatted', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-84
  it "should work immediately before or after other elements", (cb) ->
    test.markdown null, '# Heading\n    foo\nHeading\n------\n    foo\n----', [
      {type: 'document', nesting: 1}
      {type: 'heading', nesting: 1}
      {type: 'text', content: 'Heading'}
      {type: 'heading', nesting: -1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'preformatted', nesting: -1}
      {type: 'heading', nesting: 1}
      {type: 'text', content: 'Heading'}
      {type: 'heading', nesting: -1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'preformatted', nesting: -1}
      {type: 'thematic_break'}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-85
  it "should work with first line indented more", (cb) ->
    test.markdown null, '        foo\n    bar', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: '    foo\nbar'}
      {type: 'preformatted', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-86
  it "should ignore additional blank lines arround", (cb) ->
    test.markdown null, '    \n    foo\n    ', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'preformatted', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-87
  it "should include trailing spaces", (cb) ->
    test.markdown null, '    foo  ', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'foo  '}
      {type: 'preformatted', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb
