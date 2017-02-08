### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown code", ->

  # http://spec.commonmark.org/0.27/#example-88
  it "should work with back quotes", (cb) ->
    test.markdown null, '```\n<\n >\n```', [
      {type: 'document', nesting: 1}
      {type: 'code', nesting: 1, language: 'text'}
      {type: 'text', content: '<\n >'}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-89
  it "should work with tilde", (cb) ->
    test.markdown null, '~~~\n<\n >\n~~~', [
      {type: 'document', nesting: 1}
      {type: 'code', nesting: 1, language: 'text'}
      {type: 'text', content: '<\n >'}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-90
  # http://spec.commonmark.org/0.27/#example-91
  it "should use same marker for opening and closing", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '```\naaa\n~~~\n```', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa\n~~~'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '~~~\naaa\n```\n~~~', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa\n```'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-92
  # http://spec.commonmark.org/0.27/#example-93
  it "should have at least the same length for closing marker", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '````\naaa\n```\n``````', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa\n```'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '~~~~\naaa\n~~~\n~~~~', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa\n~~~'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-94
  # http://spec.commonmark.org/0.27/#example-95
  # http://spec.commonmark.org/0.27/#example-96
  it "should close at the end of document or block", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '```', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: ''}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '`````\n\n```\naaa', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: '\n```\naaa'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '> ```\n> aaa\n\nbbb', [
          {type: 'document', nesting: 1}
          {type: 'blockquote', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa'}
          {type: 'code', nesting: -1}
          {type: 'blockquote', nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', content: 'bbb'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-97
  it "should work with only blank lines", (cb) ->
    test.markdown null, '```\n\n  \n```', [
      {type: 'document', nesting: 1}
      {type: 'code', nesting: 1, language: 'text'}
      {type: 'text', content: '\n  '}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-98
  it "should work with empty content", (cb) ->
    test.markdown null, '```\n```', [
      {type: 'document', nesting: 1}
      {type: 'code', nesting: 1, language: 'text'}
      {type: 'text', content: ''}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-99
  # http://spec.commonmark.org/0.27/#example-100
  # http://spec.commonmark.org/0.27/#example-101
  it "should remove indention of opening marker", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, ' ```\n aaa\naaa\n```', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa\naaa'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '  ```\naaa\n  aaa\naaa\n  ```', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa\naaa\naaa'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '   ```\n   aaa\n    aaa\n  aaa\n   ```', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa\n aaa\naaa'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-102
  it "should fail on 4 spaces indention", (cb) ->
    test.markdown null, '    ```\n    aaa\n    ```', [
      {type: 'document', nesting: 1}
      {type: 'preformatted', nesting: 1}
      {type: 'text', content: '```\naaa\n```'}
      {type: 'preformatted', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-103
  # http://spec.commonmark.org/0.27/#example-104
  it "should allow 1-3 spaces indention on close marker", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '```\naaa\n  ```', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '```\naaa\n  ```', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

    # http://spec.commonmark.org/0.27/#example-105
    it "should fail if end marker is indented too much", (cb) ->
      test.markdown null, '```\naaa\n    ```', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'aaa\n    ```'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  # http://spec.commonmark.org/0.27/#example-106
  # http://spec.commonmark.org/0.27/#example-107
  it "should fail for spaces in marker", (cb) ->
    async.series [
      (cb) ->
        test.markdown null, '``` ```\naaa', [
          {type: 'document', nesting: 1}
          {type: 'paragraph', nesting: 1 }
          {type: 'fixed', nesting: 1}
          {type: 'text', content: ''}
          {type: 'fixed', nesting: -1}
          {type: 'softbreak'}
          {type: 'text', content: 'aaa'}
          {type: 'paragraph', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
      (cb) ->
        test.markdown null, '~~~~~~\naaa\n~~~ ~~', [
          {type: 'document', nesting: 1}
          {type: 'code', nesting: 1, language: 'text'}
          {type: 'text', content: 'aaa\n~~~ ~~'}
          {type: 'code', nesting: -1}
          {type: 'document', nesting: -1}
        ], null, cb
    ], cb

  # http://spec.commonmark.org/0.27/#example-108
  it "should interrupt paragraphs", (cb) ->
    test.markdown null, 'foo\n```\nbar\n```\nbaz', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1 }
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'code', nesting: 1, language: 'text'}
      {type: 'text', content: 'bar'}
      {type: 'code', nesting: -1}
      {type: 'paragraph', nesting: 1 }
      {type: 'text', content: 'baz'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-109
  it "should allow other blocks directly before or after code blocks", (cb) ->
    test.markdown null, 'foo\n---\n~~~\nbar\n~~~\n# baz', [
      {type: 'document', nesting: 1}
      {type: 'heading', nesting: 1, heading: 2}
      {type: 'text', content: 'foo'}
      {type: 'heading', nesting: -1}
      {type: 'code', nesting: 1, language: 'text'}
      {type: 'text', content: 'bar'}
      {type: 'code', nesting: -1}
      {type: 'heading', nesting: 1, heading: 1}
      {type: 'text', content: 'baz'}
      {type: 'heading', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-110
  it "should allow language definition", (cb) ->
    test.markdown null, '```ruby\ndef foo(x)\n  return 3\nend\n```', [
      {type: 'document', nesting: 1}
      {type: 'code', nesting: 1, language: 'ruby'}
      {type: 'text', content: 'def foo(x)\n  return 3\nend'}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-111
  it "should ignore more info after language", (cb) ->
    test.markdown null, '~~~~    ruby startline=3 $%@#$\ndef foo(x)\n  return 3\nend\n~~~~~~~', [
      {type: 'document', nesting: 1}
      {type: 'code', nesting: 1, language: 'ruby'}
      {type: 'text', content: 'def foo(x)\n  return 3\nend'}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-112
  it "should ignore more info after language", (cb) ->
    test.markdown null, '````;\n````', [
      {type: 'document', nesting: 1}
      {type: 'code', nesting: 1, language: ';'}
      {type: 'text', content: ''}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-113
  it "should also work with closing marker in same line", (cb) ->
    test.markdown null, '``` aa ```\nfoo', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'aa'}
      {type: 'fixed', nesting: -1}
      {type: 'softbreak'}
      {type: 'text', content: 'foo'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  # http://spec.commonmark.org/0.27/#example-114
  it "should fail if closing marker has info text", (cb) ->
    test.markdown null, '```\n``` aaa\n```', [
      {type: 'document', nesting: 1}
      {type: 'code', nesting: 1, language: 'text'}
      {type: 'text', content: '``` aaa'}
      {type: 'code', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb
