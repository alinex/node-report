### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown blockquote", ->

  # http://spec.commonmark.org/0.27/#example-189
  it "should work with simple block", (cb) ->
    test.markdown null, '> # Foo\n> bar\n> baz', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'heading', nesting: 1}
      {type: 'text', content: 'Foo'}
      {type: 'heading', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'softbreak'}
      {type: 'text', content: 'baz'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-190
  it "should work with omitted space after >", (cb) ->
    test.markdown null, '># Foo\n>bar\n> baz', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'heading', nesting: 1}
      {type: 'text', content: 'Foo'}
      {type: 'heading', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'softbreak'}
      {type: 'text', content: 'baz'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-191
  it "should indention of up to 3 spaces", (cb) ->
    test.markdown null, '   > # Foo\n   > bar\n > baz', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'heading', nesting: 1}
      {type: 'text', content: 'Foo'}
      {type: 'heading', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'softbreak'}
      {type: 'text', content: 'baz'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-192
  it "should fail with 4 spaces indention", (cb) ->
    test.markdown null, '    > # Foo\n    > bar\n    > baz', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: '> # Foo\n> bar\n> baz'}
      {type: 'preformatted', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-193
  it "should allow lazy continuation", (cb) ->
    test.markdown null, '> # Foo\n> bar\nbaz', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'heading', nesting: 1}
      {type: 'text', content: 'Foo'}
      {type: 'heading', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'softbreak'}
      {type: 'text', content: 'baz'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-194
  it "should allow lazy continuation within", (cb) ->
    test.markdown null, '> bar\nbaz\n> foo', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'softbreak'}
      {type: 'text', content: 'baz'}
      {type: 'softbreak'}
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-195
  # http://spec.commonmark.org/0.27/#example-196
  # http://spec.commonmark.org/0.27/#example-197
  it "should not be lazy for other elements than paragraph", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '> foo\n---', [
          {type: 'document', nesting: 1}
          {type: 'blockquote', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'foo'}
          {type: 'paragraph', nesting: -1}
          {type: 'blockquote', nesting: -1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '> - foo\n- bar', [
          {type: 'document', nesting: 1}
          {type: 'blockquote', nesting: 1}
          {type: 'list', nesting: 1}
          {type: 'item', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'foo'}
          {type: 'paragraph', nesting: -1}
          {type: 'item', nesting: -1}
          {type: 'list', nesting: -1}
          {type: 'blockquote', nesting: -1}
          {type: 'list', nesting: 1}
          {type: 'item', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'bar'}
          {type: 'paragraph', nesting: -1}
          {type: 'item', nesting: -1}
          {type: 'list', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '>     foo\n    bar', [
          {type: 'document', nesting: 1}
          {type: 'blockquote', nesting: 1}
          {type: 'preformatted', nesting: 1}
          {type: 'text', content: 'foo'}
          {type: 'preformatted', nesting: -1}
          {type: 'blockquote', nesting: -1}
          {type: 'preformatted', nesting: 1}
          {type: 'text', content: 'bar'}
          {type: 'preformatted', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-198
  it "should fail if blockquote marker is omitted", (cb) ->
    test.markdown null, '> ```\nfoo\n```', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'code', nesting: 1}
      {type: 'text', content: ''}
      {type: 'code', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'code', nesting: 1}
      {type: 'text', content: ''}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-199
  it "should allow lazy continuation with indented list", (cb) ->
    test.markdown null, '> foo\n    - bar', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'softbreak'}
      {type: 'text', content: '- bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-200
  # http://spec.commonmark.org/0.27/#example-201
  it "should allow empty blockquote", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '>', [
          {type: 'document', nesting: 1}
          {type: 'blockquote', nesting: 1}
          {type: 'blockquote', nesting: -1}
          {type: 'document', nesting: -1}
          ], null, cb
      (cb) ->
        test.markdown null, '>\n>\n>', [
          {type: 'document', nesting: 1}
          {type: 'blockquote', nesting: 1}
          {type: 'blockquote', nesting: -1}
          {type: 'document', nesting: -1}
          ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-202
  it "should ignore empty lines at start and end", (cb) ->
    test.markdown null, '>\n> foo\n>', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-203
  it "should seperate by blank line", (cb) ->
    test.markdown null, '> foo\n\n> bar', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-204
  it "should allow multiple lines", (cb) ->
    test.markdown null, '> foo\n> bar', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'softbreak'}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-205
  it "should allow two paragaphs", (cb) ->
    test.markdown null, '> foo\n>\n> bar', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-206
  it "should interrupt paragraph", (cb) ->
    test.markdown null, 'foo\n> bar', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-207
  it "should divide with thematic break", (cb) ->
    test.markdown null, '> aaa\n***\n> bbb', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'aaa'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'thematic_break'}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bbb'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-208
  # http://spec.commonmark.org/0.27/#example-209
  # http://spec.commonmark.org/0.27/#example-210
  it "should have blank line between blockquote and paragraph", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '> bar\nbaz', [
          {type: 'document', nesting: 1}
          {type: 'blockquote', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'bar'}
          {type: 'softbreak'}
          {type: 'text', content: 'baz'}
          {type: 'paragraph', nesting: -1}
          {type: 'blockquote', nesting: -1}
          {type: 'document', nesting: -1}
          ], null, cb
      (cb) ->
        test.markdown null, '> bar\n\nbaz', [
          {type: 'document', nesting: 1}
          {type: 'blockquote', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'bar'}
          {type: 'paragraph', nesting: -1}
          {type: 'blockquote', nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'baz'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
          ], null, cb
      (cb) ->
        test.markdown null, '> bar\n>\nbaz', [
          {type: 'document', nesting: 1}
          {type: 'blockquote', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'bar'}
          {type: 'paragraph', nesting: -1}
          {type: 'blockquote', nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'baz'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
          ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-211
  it "should allow lazyness in deep level", (cb) ->
    test.markdown null, '> > > foo\nbar', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'softbreak'}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-212
  it "should allow lazyness in deep level", (cb) ->
    test.markdown null, '>>> foo\n> bar\n>>baz', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'softbreak'}
      {type: 'text', content: 'bar'}
      {type: 'softbreak'}
      {type: 'text', content: 'baz'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-213
  it "should allow preformatted with 5 spaces", (cb) ->
    test.markdown null, '>     code\n\n>    not code', [
      {type: 'document', nesting: 1}
      {type: 'blockquote', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: 'code'}
      {type: 'preformatted', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'blockquote', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'not code'}
      {type: 'paragraph', nesting: -1}
      {type: 'blockquote', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb
