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
        {format: 'md', text: '!"#$%&\'()*+,-./:;\\<=>?@\\[\\\\\\]\\^\\_`{|}\\~\n'}
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

    # http://spec.commonmark.org/0.27/#example-290
    it "should interpret element if backslash is escaped itself", (cb) ->
      test.markdown null, '\\\\*emphasis*', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '\\'}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'emphasis'}
        {type: 'emphasis', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

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

    # http://spec.commonmark.org/0.27/#example-292
    # http://spec.commonmark.org/0.27/#example-293
    # http://spec.commonmark.org/0.27/#example-294
    # http://spec.commonmark.org/0.27/#example-295
    # http://spec.commonmark.org/0.27/#example-296
    it "should keep backslash escapes in preformatted or typewriter style", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '`` \\[\\` ``', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'fixed', nesting: 1}
            {type: 'text', content: '\\[\\`'}
            {type: 'fixed', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '    \\[\\]', [
            {type: 'document', nesting: 1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: '\\[\\]'}
            {type: 'preformatted', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '~~~\n\\[\\]\n~~~', [
            {type: 'document', nesting: 1}
            {type: 'code', nesting: 1}
            {type: 'text', content: '\\[\\]'}
            {type: 'code', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<http://example.com?find=\\*>', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: 'http://example.com?find=%5C*'}
            {type: 'text', content: 'http://example.com?find=\\*'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<a href="/bar\\/)">', [
            {type: 'document', nesting: 1}
            {type: 'raw', nesting: 0, format: 'html', block: true, content: '<a href="/bar\\/)">'}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-297
    # http://spec.commonmark.org/0.27/#example-298
    # http://spec.commonmark.org/0.27/#example-299
    it "should work in other elements", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo](/bar\\* "ti\\*tle")', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/bar*', title: 'ti*tle'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo]\n\n[foo]: /bar\\* "ti\\*tle"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/bar*', title: 'ti*tle'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '``` foo\\+bar\nfoo\n```', [
            {type: 'document', nesting: 1}
            {type: 'code', nesting: 1, language: 'foo\\+bar'}
            {type: 'text', content: 'foo'}
            {type: 'code', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

  describe "entities", ->

    # http://spec.commonmark.org/0.27/#example-300
    it "should interpret them", (cb) ->
      test.markdown null, '&nbsp; &amp; &copy; &AElig; &Dcaron;\n&frac34; &HilbertSpace; &DifferentialD;\n&ClockwiseContourIntegral; &ngE;', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '  & © Æ Ď'}
        {type: 'softbreak'}
        {type: 'text', content: '¾ ℋ ⅆ'}
        {type: 'softbreak'}
        {type: 'text', content: '∲ ≧̸'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-301
    it "should allow numeric", (cb) ->
      test.markdown null, '&#35; &#1234; &#992; &#98765432; &#0;', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '# Ӓ Ϡ � �'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-302
    it "should allow hexadecimal", (cb) ->
      test.markdown null, '&#X22; &#XD06; &#xcab;', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '" ആ ಫ'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-303
    it "should fail for non entities", (cb) ->
      test.markdown null, '&nbsp &x; &#; &#x;\n&ThisIsNotDefined; &hi?;', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '&nbsp &x; &#; &#x;'}
        {type: 'softbreak'}
        {type: 'text', content: '&ThisIsNotDefined; &hi?;'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-304
    it "should fail for entities with missing ;", (cb) ->
      test.markdown null, '&copy', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '&copy'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-305
    it "should fail for not html5 entities", (cb) ->
      test.markdown null, '&MadeUpEntity;', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '&MadeUpEntity;'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-306
    # http://spec.commonmark.org/0.27/#example-307
    # http://spec.commonmark.org/0.27/#example-308
    # http://spec.commonmark.org/0.27/#example-309
    it "should work in different elements", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<a href="&ouml;&ouml;.html">', [
            {type: 'document', nesting: 1}
            {type: 'raw', format: 'html', block: true, content: '<a href="&ouml;&ouml;.html">'}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo](/f&ouml;&ouml; "f&ouml;&ouml;")', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/f%C3%B6%C3%B6', title: 'föö'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo]\n\n[foo]: /f&ouml;&ouml; "f&ouml;&ouml;"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/f%C3%B6%C3%B6', title: 'föö'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '``` f&ouml;&ouml;\nfoo\n```', [
            {type: 'document', nesting: 1}
            {type: 'code', nesting: 1, language: 'f&ouml;&ouml;'}
            {type: 'text', content: 'foo'}
            {type: 'code', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-310
    # http://spec.commonmark.org/0.27/#example-311
    it "should fail in code or preformatted", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '`f&ouml;&ouml;`', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'fixed', nesting: 1}
            {type: 'text', content: 'f&ouml;&ouml;'}
            {type: 'fixed', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '    f&ouml;f&ouml;', [
            {type: 'document', nesting: 1}
            {type: 'preformatted', nesting: 1}
            {type: 'text', content: 'f&ouml;f&ouml;'}
            {type: 'preformatted', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

  describe "hard breaks", ->

    # http://spec.commonmark.org/0.27/#example-603
    it "should work if preceded by two  spaces", (cb) ->
      test.markdown null, 'foo  \nbaz', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'hardbreak'}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-604
    it "should work if line ends with backslash", (cb) ->
      test.markdown null, 'foo\\\nbaz', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'hardbreak'}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-605
    it "should work if preceded by more than two spaces", (cb) ->
      test.markdown null, 'foo       \nbaz', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'hardbreak'}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-606
    # http://spec.commonmark.org/0.27/#example-607
    it "should ignore leading spaces in next line", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, 'foo  \n     baz', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'hardbreak'}
            {type: 'text', content: 'baz'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo\\\n     baz', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'hardbreak'}
            {type: 'text', content: 'baz'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-608
    # http://spec.commonmark.org/0.27/#example-609
    it "should allow within emphasis", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '*foo  \nbaz*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'hardbreak'}
            {type: 'text', content: 'baz'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '*foo\\\nbaz*', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'hardbreak'}
            {type: 'text', content: 'baz'}
            {type: 'emphasis', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-610
    # http://spec.commonmark.org/0.27/#example-611
    it "should fail within fixed code", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '`foo  \nbaz`', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'fixed', nesting: 1}
            {type: 'text', content: 'foo baz'}
            {type: 'fixed', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '`foo\\\nbaz`', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'fixed', nesting: 1}
            {type: 'text', content: 'foo\\ baz'}
            {type: 'fixed', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-612
    # http://spec.commonmark.org/0.27/#example-613
    it "should fail within html", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '<a href="foo  \nbar">', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'raw', format: 'html', content: '<a href="foo  \nbar">'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '<a href="foo\\\nbar">', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'raw', format: 'html', content: '<a href="foo\\\nbar">'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-614
    # http://spec.commonmark.org/0.27/#example-615
    # http://spec.commonmark.org/0.27/#example-616
    # http://spec.commonmark.org/0.27/#example-617
    it "should be impossible at end of block or document", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, 'foo\\', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo\\'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'foo  ', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '### foo\\', [
            {type: 'document', nesting: 1}
            {type: 'heading', nesting: 1}
            {type: 'text', content: 'foo\\'}
            {type: 'heading', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '### foo  ', [
            {type: 'document', nesting: 1}
            {type: 'heading', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'heading', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

  describe "soft breaks", ->

    # http://spec.commonmark.org/0.27/#example-618
    it "should work on newlines", (cb) ->
      test.markdown null, 'foo\nbaz', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'softbreak'}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-619
    it "should remove preceding whitespace on next line", (cb) ->
      test.markdown null, 'foo\n baz', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'foo'}
        {type: 'softbreak'}
        {type: 'text', content: 'baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "literal", ->

    # http://spec.commonmark.org/0.27/#example-620
    it "should work with special chars", (cb) ->
      test.markdown null, 'hello $.;\'there', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'hello $.;\'there'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-621
    it "should work with non latin", (cb) ->
      test.markdown null, 'Foo χρῆν', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Foo χρῆν'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-622
    it "should preserve internal spaces", (cb) ->
      test.markdown null, 'Multiple     spaces', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Multiple     spaces'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
