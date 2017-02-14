### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown fixed", ->

  # http://spec.commonmark.org/0.27/#example-286
  it "should parse inline sequentially", (cb) ->
    test.markdown null, '`hi`lo`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'hi'}
      {type: 'fixed', nesting: -1}
      {type: 'text', content: 'lo`'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-312
  it "should work with simple code", (cb) ->
    test.markdown null, '`foo`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'fixed', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-313
  it "should work with multiple backquotes", (cb) ->
    test.markdown null, '`` foo ` bar  ``', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'foo ` bar'}
      {type: 'fixed', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-314
  it "should work with nested backquotes", (cb) ->
    test.markdown null, '` `` `', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: '``'}
      {type: 'fixed', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-315
  it "should treat line endings like spaces", (cb) ->
    test.markdown null, '``\nfoo\n``', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'fixed', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-316
  it "should collapse into single space", (cb) ->
    test.markdown null, '`foo   bar\n  baz`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'foo bar baz'}
      {type: 'fixed', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-317
  it "should keep unicode no-breaking space", (cb) ->
    test.markdown null, '`a  b`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'a  b'}
      {type: 'fixed', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-318
  it "should keep back quotes within", (cb) ->
    test.markdown null, '`foo `` bar`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'foo `` bar'}
      {type: 'fixed', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-319
  it "should keep back quotes within", (cb) ->
    test.markdown null, '`foo\\`bar`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'foo\\'}
      {type: 'fixed', nesting: -1}
      {type: 'text', content: 'bar`'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-320
  it "should have higher priority for code", (cb) ->
    test.markdown null, '*foo`*`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: '*foo'}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: '*'}
      {type: 'fixed', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-321
  it "should break link definition", (cb) ->
    test.markdown null, '[not a `link](/foo`)', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: '[not a '}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'link](/foo'}
      {type: 'fixed', nesting: -1}
      {type: 'text', content: ')'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-322
  it "should break html tags", (cb) ->
    test.markdown null, '`<a href="`">`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: '<a href="'}
      {type: 'fixed', nesting: -1}
      {type: 'text', content: '">`'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

#  # http://spec.commonmark.org/0.27/#example-323
#  it.only "should fail in html tags", (cb) ->
#    test.markdown null, '<a href="`">`', [
#      {type: 'document', nesting: 1}
#      {type: 'paragraph', nesting: 1}
#      {type: 'fixed', nesting: 1}
#      {type: 'text', content: '<a href="'}
#      {type: 'fixed', nesting: -1}
#      {type: 'text', content: '">`'}
#      {type: 'paragraph', nesting: -1}
#      {type: 'document', nesting: -1}
#    ], null, cb

  # http://spec.commonmark.org/0.27/#example-324
  it "should break auto link", (cb) ->
    test.markdown null, '`<http://foo.bar.`baz>`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: '<http://foo.bar.'}
      {type: 'fixed', nesting: -1}
      {type: 'text', content: 'baz>`'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

#################################################
# example 325

  # http://spec.commonmark.org/0.27/#example-326
  # http://spec.commonmark.org/0.27/#example-327
  it "should ignore if end marker not matched", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '```foo``', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: '```foo``'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '`foo', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: '`foo'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb
