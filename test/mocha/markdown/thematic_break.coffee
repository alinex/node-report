### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown thematic break", ->

  # http://spec.commonmark.org/0.27/#example-13
  it "should work with three characters", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '***', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '---', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '___', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-14
  # http://spec.commonmark.org/0.27/#example-15
  it "should fail with wrong characters", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '+++', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: '+++'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '===', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: '==='}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-16
  it "should fail with not enough characters", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '--', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: '--'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '**', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: '**'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '__', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: '__'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb


  # http://spec.commonmark.org/0.27/#example-17
  it "should work with one to three spaces indent", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, ' ***', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '  ***', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '   ***', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-18
  # http://spec.commonmark.org/0.27/#example-19
  it "should fail with too much indention", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '    ****', [
          {type: 'document', nesting: 1}
          {type: 'preformatted', nesting: 1}
          {type: 'text', content: '****'}
          {type: 'preformatted', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, 'Foo\n    ***', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'Foo'}
          {type: 'softbreak'}
          {type: 'text', content: '***'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-20
  it "should work with more than three characters", (cb) ->
    test.markdown null, '_____________________________________', [
      {type: 'document', nesting: 1}
      {type: 'thematic_break'}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-21
  # http://spec.commonmark.org/0.27/#example-22
  # http://spec.commonmark.org/0.27/#example-23
  it "should work with spaces between the characters", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, ' - - -', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, ' **  * ** * ** * **', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '-     -      -      -', [
          {type: 'document', nesting: 1}
          {type: 'thematic_break'}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-24
  it "should work with spaces at the end", (cb) ->
    test.markdown null, '- - - -    ', [
      {type: 'document', nesting: 1}
      {type: 'thematic_break'}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-25
  it "should fail with other characters within the line", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '_ _ _ _ a', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: '_ _ _ _ a'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, 'a------', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'a------'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '---a---', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: '---a---'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-26
  it "should fail with different line characters", (cb) ->
    test.markdown null, ' *-*', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'emphasis', nesting: 1}
      {type: 'text', content: '-'}
      {type: 'emphasis', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-27
  it "should work without blank lines before and after", (cb) ->
    test.markdown null, '- foo\n***\n+ bar', [
      {type: 'document', nesting: 1}
      {type: 'list', nesting: 1}
      {type: 'item', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'list', nesting: -1}
      {type: 'thematic_break'}
      {type: 'list', nesting: 1}
      {type: 'item', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'list', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-28
  it "should interrupt a paragraph", (cb) ->
    test.markdown null, 'foo\n***\nbar', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'thematic_break'}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-29
  it "should fail if line may interpreted as setext", (cb) ->
    test.markdown null, 'Foo\n---\nbar', [
      {type: 'document', nesting: 1}
      {type: 'heading', heading: 2, nesting: 1}
      {type: 'text', content: 'Foo'}
      {type: 'heading', heading: 2, nesting: -1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-30
  it "should work in favor of ordered list", (cb) ->
    test.markdown null, '* Foo\n* * *\n* Bar', [
      {type: 'document', nesting: 1}
      {type: 'list', nesting: 1}
      {type: 'item', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'Foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'list', nesting: -1}
      {type: 'thematic_break'}
      {type: 'list', nesting: 1}
      {type: 'item', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'Bar'}
      {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'list', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-31
  it "should work in bullet list", (cb) ->
    test.markdown null, '- Foo\n- * * *', [
      {type: 'document', nesting: 1}
      {type: 'list', nesting: 1}
      {type: 'item', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'text', content: 'Foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'item', nesting: -1}
      {type: 'item', nesting: 1}
      {type: 'thematic_break'}
      {type: 'item', nesting: -1}
      {type: 'list', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb
