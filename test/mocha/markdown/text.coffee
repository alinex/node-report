### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown text", ->

  describe "tabs", ->

    # http://spec.commonmark.org/0.27/#example-1
    it "should keep them in preformatted", (cb) ->
      test.markdown null, '\tfoo\tbaz\t\tbim', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'foo\tbaz\t\tbim'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-2
    it "should keep them in preformatted (indented by spaces+tab)", (cb) ->
      test.markdown null, '  \tfoo\tbaz\t\tbim', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'foo\tbaz\t\tbim'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-3
    it "should keep them in preformatted (multiline)", (cb) ->
      test.markdown null, '    a\ta\n    ὐ\ta', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'a\ta\nὐ\ta'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-4
    it "should allow continuation indent in list", (cb) ->
      test.markdown null, '  - foo\n\n\tbar', [
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

    # http://spec.commonmark.org/0.27/#example-5
    it "should allow continuation indent in list (multiple tabs)", (cb) ->
      test.markdown null, '- foo\n\n\t\tbar', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'paragraph', nesting: -1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: '  bar'}
        {type: 'preformatted', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-6
    it "should make preformatted if multiple used in blockquote", (cb) ->
      test.markdown null, '>\t\tfoo', [
        {type: 'document', nesting: 1}
        {type: 'blockquote', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: '  foo'}
        {type: 'preformatted', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-7
    it "should make preformatted if multiple used in list", (cb) ->
      test.markdown null, '-\t\tfoo', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1}
        {type: 'item', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: '  foo'}
        {type: 'preformatted', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-8
    it "should continue preformatted made with spaces", (cb) ->
      test.markdown null, '    foo\n\tbar', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: 'foo\nbar'}
        {type: 'preformatted', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-9
    it "should indent in lists with alternative tabs (4 spaces)", (cb) ->
      test.markdown null, ' - foo\n   - bar\n\t - baz', [
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
        {type: 'list', nesting: 1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-10
    it "should ignore tab as atx heading separator", (cb) ->
      test.markdown null, '#\tFoo', [
        {type: 'document', nesting: 1}
        {type: 'heading', nesting: 1}
        {type: 'text', content: 'Foo'}
        {type: 'heading', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-11
    it "should ignore tabs in thematic break", (cb) ->
      test.markdown null, '*\t*\t*\t', [
        {type: 'document', nesting: 1}
        {type: 'thematic_break'}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "precedence", ->

    # http://spec.commonmark.org/0.27/#example-12
    it "should have precedence in block above inline", (cb) ->
      test.markdown null, '- `one\n- two`', [
        {type: 'document', nesting: 1}
        {type: 'list', nesting: 1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '`one'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'item', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'two`'}
        {type: 'paragraph', nesting: -1}
        {type: 'item', nesting: -1}
        {type: 'list', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
