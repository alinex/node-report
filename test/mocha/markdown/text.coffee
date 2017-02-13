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

  describe "escapes", ->

    # http://spec.commonmark.org/0.27/#example-287
    it "should remove backslash before ASCII punctuation", (cb) ->
      test.markdown null, '\\!"\\#\\$\\%\\&\\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\]\\^\\_\\`\\{\\|\\}\\~', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], [
        {format: 'md', text: '!"#$%&\'()*+,-./:;\\<=>?@\\[\\\\]\\^\\_`{|}\\~\n'}
        {format: 'text', text: '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'}
        {format: 'html', text: '!&quot;#$%&amp;&#39;()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~'}
      ], cb

    # http://spec.commonmark.org/0.27/#example-288
    it "should keep backslash before other characters", (cb) ->
      test.markdown null, '\\→\\A\\a\\ \\3\\φ\\«', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '\\→\\A\\a\\ \\3\\φ\\«'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-289
    it "should not interpret markdown if escaped", (cb) ->
      test.markdown null, """
        \\*not emphasized*
        \\<br/> not a tag
        \\[not a link](/foo)
        \\`not code`
        1\\. not a list
        \\* not a list
        \\# not a heading
        \\[foo]: /url "not a reference"
      """, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: "*not emphasized*"}
        {type: 'softbreak'}
        {type: 'text', content: "<br/> not a tag"}
        {type: 'softbreak'}
        {type: 'text', content: "[not a link](/foo)"}
        {type: 'softbreak'}
        {type: 'text', content: "`not code`"}
        {type: 'softbreak'}
        {type: 'text', content: "1. not a list"}
        {type: 'softbreak'}
        {type: 'text', content: "* not a list"}
        {type: 'softbreak'}
        {type: 'text', content: "# not a heading"}
        {type: 'softbreak'}
        {type: 'text', content: "[foo]: /url \"not a reference\""}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

#    # http://spec.commonmark.org/0.27/#example-290
#    it "should interpret element if backslash is escaped itself", (cb) ->
#      test.markdown null, '\\\\*emphasis*', [
#        {type: 'document', nesting: 1}
#        {type: 'paragraph', nesting: 1}
#        {type: 'text', content: '\\'}
#        {type: 'emphasis', nesting: 1}
#        {type: 'text', content: 'emphasis'}
#        {type: 'emphasis', nesting: -1}
#        {type: 'paragraph', nesting: -1}
#        {type: 'document', nesting: -1}
#      ], null, cb

    # http://spec.commonmark.org/0.27/#example-291
    it "should interpret hard line break", (cb) ->
      test.markdown null, 'foo\\\nbar', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'hardbreak'}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

#    # http://spec.commonmark.org/0.27/#example-292-296
#    it "should keep backslash escapes in preformatted or typewriter style", (cb) ->
#      test.markdown null, '`` \[\` ``', [
#        {type: 'document', nesting: 1}
#        {type: 'paragraph', nesting: 1}
#        {type: 'typewriter', nesting: 1}
#        {type: 'text', content: '\[\`'}
#        {type: 'typewriter', nesting: -1}
#        {type: 'paragraph', nesting: -1}
#        {type: 'document', nesting: -1}
#      ], null, cb
####################################### more to come
