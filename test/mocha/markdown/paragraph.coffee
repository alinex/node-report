### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown paragraph", ->

  # http://spec.commonmark.org/0.27/#example-180
  it "should work with single line paragraphs", (cb) ->
    test.markdown null, 'aaa\n\nbbb', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'aaa'}
      {type: 'paragraph', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bbb'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-181
  it "should work with multiple lines in paragraph", (cb) ->
    test.markdown null, 'aaa\nbbb\n\nccc\nddd', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'aaa'}
      {type: 'softbreak'}
      {type: 'text', content: 'bbb'}
      {type: 'paragraph', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'ccc'}
      {type: 'softbreak'}
      {type: 'text', content: 'ddd'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-182
  it "should work with multiple blank lines in paragraph", (cb) ->
    test.markdown null, 'aaa\nbbb\n\nccc\nddd', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'aaa'}
      {type: 'softbreak'}
      {type: 'text', content: 'bbb'}
      {type: 'paragraph', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'ccc'}
      {type: 'softbreak'}
      {type: 'text', content: 'ddd'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-183
  it "should work with 1-3 leading spaces ignored", (cb) ->
    test.markdown null, '  aaa\n bbb', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'aaa'}
      {type: 'softbreak'}
      {type: 'text', content: 'bbb'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-184
  it "should work with multiple leading spaces after the first line", (cb) ->
    test.markdown null, 'aaa\n             bbb\n                                       ccc', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'aaa'}
      {type: 'softbreak'}
      {type: 'text', content: 'bbb'}
      {type: 'softbreak'}
      {type: 'text', content: 'ccc'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-185
  it "should work with first line indented 3 spaces", (cb) ->
    test.markdown null, '   aaa\nbbb', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'aaa'}
      {type: 'softbreak'}
      {type: 'text', content: 'bbb'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-186
  it "should fail with 4 or more spaces", (cb) ->
    test.markdown null, '    aaa\nbbb', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'aaa'}
      {type: 'preformatted', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bbb'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-187
  it "should work with line break if two or more spaces", (cb) ->
    test.markdown null, 'aaa     \nbbb     ', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'aaa'}
      {type: 'hardbreak'}
      {type: 'text', content: 'bbb'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb
