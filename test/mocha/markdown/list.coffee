### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown list", ->

  describe "items", ->

    # http://spec.commonmark.org/0.27/#example-214
    it "should show some blocks", (cb) ->
      test.markdown null, 'A paragraph\nwith two lines.\n\n    indented code\n\n> A block quote.', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'A paragraph'}
        {type: 'softbreak'}
        {type: 'text', content: 'with two lines.'}
        {type: 'paragraph', nesting: -1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'indented code'}
        {type: 'preformatted', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'A block quote.'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-215
    it "should include all in ordered list item", (cb) ->
      test.markdown null, '1.  A paragraph\n    with two lines.\n\n        indented code\n\n    > A block quote.', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'A paragraph'}
        {type: 'softbreak'}
        {type: 'text', content: 'with two lines.'}
        {type: 'paragraph', nesting: -1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'indented code'}
        {type: 'preformatted', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'A block quote.'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-216
    it "should fail for second line too less indented", (cb) ->
      test.markdown null, '- one\n\n two', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-217
    it "should add two paragraphs to item", (cb) ->
      test.markdown null, '- one\n\n  two', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-218
    # indention one space less to allow seamless reparse
    it "should have following preformatted text", (cb) ->
      test.markdown null, ' -   one\n\n    two', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-219
    it "should have two paragraphs instead preformatted", (cb) ->
      test.markdown null, ' -    one\n\n      two', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-220
    it "should work with indention in blockquote", (cb) ->
      test.markdown null, '> > 1.  one\n>>\n>>     two', [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-221
    it "should fail if continue indention is too less", (cb) ->
      test.markdown null, '>>- one\n>>\n  >  > two', [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-222
    it "should fail on missing space after list symbol", (cb) ->
      test.markdown null, '-one\n\n2.two', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '-one'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '2.two'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-223
    it "should allow more than one space lines", (cb) ->
      test.markdown null, '- foo\n\n\n  bar', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
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

    # http://spec.commonmark.org/0.27/#example-224
    it "should contain other elements within", (cb) ->
      test.markdown null, '1.  foo\n\n    ```\n    bar\n    ```\n\n    baz\n\n    > bam', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'code', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'code', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bam'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-225
    it "should allow indented block with space lines", (cb) ->
      test.markdown null, '- Foo\n\n      bar\n\n\n      baz', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'bar\n\n\nbaz'}
        {type: 'preformatted', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-226
    it "should allow start numbers with 9 digits", (cb) ->
      test.markdown null, '123456789. ok', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 123456789}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'ok'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-227
    it "should fail on start numbers with more than 9 digits", (cb) ->
      test.markdown null, '1234567890. not ok', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '1234567890. not ok'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-228
    it "should allow start number 0", (cb) ->
      test.markdown null, '0. ok', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 0}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'ok'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-229
    it "should ignore leading 0 in start numbers", (cb) ->
      test.markdown null, '003. ok', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 3}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'ok'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-230
    it "should fail on negative start numbers", (cb) ->
      test.markdown null, '-1. not ok', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '-1. not ok'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-231
    # http://spec.commonmark.org/0.27/#example-232
    it "should allow indented text", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '- foo\n\n      bar', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'preformatted', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          test.markdown null, '  10.  foo\n\n           bar', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 10}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'preformatted', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-233
    # http://spec.commonmark.org/0.27/#example-234
    # http://spec.commonmark.org/0.27/#example-235
    it "should have preformatted and paragraphs", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '    indented code\n\nparagraph\n\n    more code', [
            {type: 'document', nesting: 1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'indented code'}
            {type: 'preformatted', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'paragraph'}
            {type: 'paragraph', nesting: -1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'more code'}
            {type: 'preformatted', nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          test.markdown null, '1.     indented code\n\n   paragraph\n\n       more code', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'indented code'}
            {type: 'preformatted', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'paragraph'}
            {type: 'paragraph', nesting: -1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'more code'}
            {type: 'preformatted', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          test.markdown null, '1.      indented code\n\n   paragraph\n\n       more code', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: ' indented code'}
            {type: 'preformatted', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'paragraph'}
            {type: 'paragraph', nesting: -1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'more code'}
            {type: 'preformatted', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-236
    # http://spec.commonmark.org/0.27/#example-237
    # http://spec.commonmark.org/0.27/#example-238
    it "should not bring complete block in list if first is idented more", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '   foo\n\nbar', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          test.markdown null, '-    foo\n\n  bar', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
            ], null, cb
        (cb) ->
          test.markdown null, '-  foo\n\n   bar', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
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
      ], cb

    # http://spec.commonmark.org/0.27/#example-239
    it "should work with empty bullet lines but text afterwards", (cb) ->
      test.markdown null, '-\n  foo\n-\n  ```\n  bar\n  ```\n-\n      baz', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'code', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'code', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'baz'}
        {type: 'preformatted', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-240
    it "should ignore indention of empty starting line", (cb) ->
      test.markdown null, '-   \n  foo', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-241
    it "should fail for more than one blank line at start", (cb) ->
      test.markdown null, '-\n\n  foo', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-242
    # http://spec.commonmark.org/0.27/#example-243
    # http://spec.commonmark.org/0.27/#example-244
    it "should allow for empty items", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '- foo\n-\n- bar', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '- foo\n-   \n- bar', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '1. foo\n2.\n3. bar', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-245
    it "should work with only empty item", (cb) ->
      test.markdown null, '*', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-246
    it "should not break paragraphs", (cb) ->
      test.markdown null, 'foo\n*\n\nfoo\n1.', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'softbreak'}
        {type: 'text', content: '*'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'softbreak'}
        {type: 'text', content: '1.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-247
    # http://spec.commonmark.org/0.27/#example-248
    # http://spec.commonmark.org/0.27/#example-249
    it "should work indented one to three space", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, ' 1.  A paragraph\n     with two lines.\n\n         indented code\n\n     > A block quote.', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'A paragraph'}
            {type: 'softbreak'}
            {type: 'text', content: 'with two lines.'}
            {type: 'paragraph', nesting: -1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'indented code'}
            {type: 'preformatted', nesting: -1}
            {type: 'blockquote', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'A block quote.'}
            {type: 'paragraph', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '  1.  A paragraph\n      with two lines.\n\n          indented code\n\n      > A block quote.', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'A paragraph'}
            {type: 'softbreak'}
            {type: 'text', content: 'with two lines.'}
            {type: 'paragraph', nesting: -1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'indented code'}
            {type: 'preformatted', nesting: -1}
            {type: 'blockquote', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'A block quote.'}
            {type: 'paragraph', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '   1.  A paragraph\n       with two lines.\n\n           indented code\n\n       > A block quote.', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'A paragraph'}
            {type: 'softbreak'}
            {type: 'text', content: 'with two lines.'}
            {type: 'paragraph', nesting: -1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'indented code'}
            {type: 'preformatted', nesting: -1}
            {type: 'blockquote', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'A block quote.'}
            {type: 'paragraph', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-250
    it "should fail on 4 spaces indent", (cb) ->
      test.markdown null, '    1.  A paragraph\n        with two lines.\n\n            indented code\n\n        > A block quote.', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: '1.  A paragraph\n    with two lines.\n\n        indented code\n\n    > A block quote.'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-251
    it "should work indented with lazy paragraph", (cb) ->
      test.markdown null, '  1.  A paragraph\nwith two lines.\n\n          indented code\n\n      > A block quote.', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'A paragraph'}
        {type: 'softbreak'}
        {type: 'text', content: 'with two lines.'}
        {type: 'paragraph', nesting: -1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'indented code'}
        {type: 'preformatted', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'A block quote.'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-252
    it "should allow remove part of indentation", (cb) ->
      test.markdown null, '  1.  A paragraph\n    with two lines.', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'A paragraph'}
        {type: 'softbreak'}
        {type: 'text', content: 'with two lines.'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-253
    # http://spec.commonmark.org/0.27/#example-254
    it "should allow laziness in nested structures", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '> 1. > Blockquote\ncontinued here.', [
            {type: 'document', nesting: 1}
            {type: 'blockquote', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'blockquote', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'Blockquote'}
            {type: 'softbreak'}
            {type: 'text', content: 'continued here.'}
            {type: 'paragraph', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '> 1. > Blockquote\n> continued here.', [
            {type: 'document', nesting: 1}
            {type: 'blockquote', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'blockquote', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'Blockquote'}
            {type: 'softbreak'}
            {type: 'text', content: 'continued here.'}
            {type: 'paragraph', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'blockquote', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-255
    it "should allow remove part of indentation", (cb) ->
      test.markdown null, '- foo\n  - bar\n    - baz\n      - boo', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'boo'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-256
    it "should not make sublists with indention of one", (cb) ->
      test.markdown null, '- foo\n - bar\n  - baz\n   - boo', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'boo'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-257
    it "should need more spaces indent if marker is wider", (cb) ->
      test.markdown null, '10) foo\n    - bar', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 10}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
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

    # http://spec.commonmark.org/0.27/#example-258
    it "should fail sublist on wider marker", (cb) ->
      test.markdown null, '10) foo\n   - bar', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered', start: 10}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-259
    # http://spec.commonmark.org/0.27/#example-260
    it "should sublist in first line", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '- - foo', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '1. - 2. foo', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 2}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-261
    it "should work with containing heading", (cb) ->
      test.markdown null, '- # Foo\n- Bar\n  ---\n  baz', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'heading', nesting: 1}
        {type: 'text', content: 'Foo'}
        {type: 'heading', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'heading', nesting: 1}
        {type: 'text', content: 'Bar'}
        {type: 'heading', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "itself", ->

    # http://spec.commonmark.org/0.27/#example-262
    # http://spec.commonmark.org/0.27/#example-263
    it "should start new list on change of marker type", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '- foo\n- bar\n+ baz', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'baz'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '1. foo\n2. bar\n3) baz', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'list', nesting: 1, list: 'ordered', start: 3}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'baz'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-264
    it "should interrupt paragraph", (cb) ->
      test.markdown null, 'Foo\n- bar\n- baz', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-265
    it "should not interrupt paragraph if not starting with 1", (cb) ->
      test.markdown null, 'The number of windows in my house is\n14.  The number of doors is 6.', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'The number of windows in my house is'}
        {type: 'softbreak'}
        {type: 'text', content: '14.  The number of doors is 6.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-266
    it "should interrupt paragraph if starting with 1", (cb) ->
      test.markdown null, 'The number of windows in my house is\n1.  The number of doors is 6.', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'The number of windows in my house is'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'ordered', start: 1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'The number of doors is 6.'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-267
    # http://spec.commonmark.org/0.27/#example-268
    it "should allow blank lines between items", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '- foo\n\n- bar\n\n\n- baz', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'baz'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '- foo\n  - bar\n    - baz\n\n\n      bim', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'baz'}
            {type: 'paragraph', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bim'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-269
    # http://spec.commonmark.org/0.27/#example-270
    it "should separate lists using html", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '- foo\n- bar\n\n<!-- -->\n\n- baz\n- bim', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'comment'}
            {type: 'list', nesting: 1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'baz'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'bim'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '-   foo\n\n    notcode\n\n-   foo\n\n<!-- -->\n\n    code', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'notcode'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'comment'}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'code'}
            {type: 'preformatted', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-271
    # http://spec.commonmark.org/0.27/#example-272
    it "should keep items on same level if indented too less", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '- a\n - b\n  - c\n   - d\n    - e\n   - f\n  - g\n - h\n- i', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'a'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'b'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'c'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'd'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'e'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'f'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'g'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'h'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'i'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '1. a\n\n  2. b\n\n    3. c', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'ordered', start: 1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'a'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'b'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'c'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-273
    it "should allow blank line between items", (cb) ->
      test.markdown null, '- a\n- b\n\n- c', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'b'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'c'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-274
    it "should allow blank line after empty item", (cb) ->
      test.markdown null, '* a\n*\n\n* c', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'c'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-275
    # http://spec.commonmark.org/0.27/#example-276
    it "should allow item with two paragraphs", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '- a\n- b\n\n  c\n- d', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'a'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'b'}
            {type: 'paragraph', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'c'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'd'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '- a\n- b\n\n  [ref]: /url\n- d', [
            {type: 'document', nesting: 1}
            {type: 'list', nesting: 1, list: 'bullet'}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'a'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'b'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'item', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'd'}
            {type: 'paragraph', nesting: -1}
            {type: 'item', nesting: -1}
            {type: 'list', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

  describe 'tight', ->

    # http://spec.commonmark.org/0.27/#example-277
    it "should work with blank lines in code block", (cb) ->
      test.markdown null, '- a\n- ```\n  b\n\n\n  ```\n- c', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'code', nesting: 1}
        {type: 'text', content: 'b'}
        {type: 'code', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'c'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-278
    it "should work with loose sub list", (cb) ->
      test.markdown null, '- a\n  - b\n\n    c\n- d', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'b'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'c'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'd'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-279
    it "should work with blank line in blockquote", (cb) ->
      test.markdown null, '* a\n  > b\n  >\n* c', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'b'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'c'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-280
    it.skip "should work with continuing blocks not separated by blanks", (cb) ->
      test.markdown null, '- a\n  > b\n  ```\n  c\n  ```\n- d', [
#      test.markdown null, '   - a\n     > b\n     ```\n     c\n     ```\n   - d', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'b'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'code', nesting: 1}
        {type: 'text', content: 'c'}
        {type: 'code', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'd'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-281
    it "should work with single paragraph", (cb) ->
      test.markdown null, '- a', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-282
    it "should work with single paragraph and sub list", (cb) ->
      test.markdown null, '- a\n  - b', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'b'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-283
    it "should fail with blank line between blocks", (cb) ->
      test.markdown null, '1. ```\n   foo\n   ```\n\n   bar', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'ordered'}
        {type: 'item', nesting: 1}
        {type: 'code', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'code', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-284
    it "should work with outer list loose and inner tight", (cb) ->
      test.markdown null, '* foo\n  * bar\n\n  baz', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-285
    it "should work with outer list loose and inner tight", (cb) ->
      test.markdown null, '- a\n  - b\n  - c\n\n- d\n  - e\n  - f', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'a'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'b'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'c'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'd'}
        {type: 'paragraph', nesting: -1}
        {type: 'list', nesting: 1, list: 'bullet'}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'e'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'f'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
