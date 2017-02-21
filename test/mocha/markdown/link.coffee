### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown link", ->

  describe "reference definition", ->

    # http://spec.commonmark.org/0.27/#example-157
    # http://spec.commonmark.org/0.27/#example-158
    # http://spec.commonmark.org/0.27/#example-159
    # http://spec.commonmark.org/0.27/#example-160
    it "should allow simple use", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo]: /url "title"\n\n[foo]', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '   [foo]: \n      /url  \n           \'the title\'  \n\n[foo]', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url', title: 'the title'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[Foo*bar\\]]:my_(url) \'title (with parens)\'\n\n[Foo*bar\\]]', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: 'my_(url)', title: 'title (with parens)'}
            {type: 'text', content: 'Foo*bar]'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[Foo bar]:\n<my%20url>\n\'title\'\n\n[Foo bar]', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: 'my%20url', title: 'title'}
            {type: 'text', content: 'Foo bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-161
    it "should allow title over multiple lines", (cb) ->
      test.markdown null, '[foo]: /url \'\ntitle\nline1\nline2\n\'\n\n[foo]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: '\ntitle\nline1\nline2\n'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-162
    it "should fail for blank line in title", (cb) ->
      test.markdown null, '[foo]: /url \'title\n\nwith blank line\'\n\n[foo]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[foo]: /url \'title'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'with blank line\''}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[foo]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-163
    it "should allow without title", (cb) ->
      test.markdown null, '[foo]:\n/url\n\n[foo]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-164
    it "should fail without link destination", (cb) ->
      test.markdown null, '[foo]:\n\n[foo]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[foo]:'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[foo]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-165
    it "should allow escapes in title and destination", (cb) ->
      test.markdown null, '[foo]: /url\\bar\\*baz "foo\\"bar\\baz"\n\n[foo]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url%5Cbar*baz', title: 'foo"bar\\baz'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-166
    it "should allow link before definition", (cb) ->
      test.markdown null, '[foo]\n\n[foo]: url', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: 'url'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-167
    it "should use first definition", (cb) ->
      test.markdown null, '[foo]\n\n[foo]: first\n[foo]: second', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: 'first'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-168
    # http://spec.commonmark.org/0.27/#example-169
    it "should allow case insensitive matching", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[FOO]: /url\n\n[Foo]', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url'}
            {type: 'text', content: 'Foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[ΑΓΩ]: /φου\n\n[αγω]', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/%CF%86%CE%BF%CF%85'}
            {type: 'text', content: 'αγω'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-170
    it "should do nothing for only definition", (cb) ->
      test.markdown null, '[foo]: /url', [
        {type: 'document', nesting: 1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-171
    it "should ignore definition if not used", (cb) ->
      test.markdown null, '[\nfoo\n]: /url\nbar', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-172
    it "should fail for non whitespace after title", (cb) ->
      test.markdown null, '[foo]: /url "title" ok', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[foo]: /url "title" ok'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-173
    it "should fail with title starting in next line", (cb) ->
      test.markdown null, '[foo]: /url\n"title" ok', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '"title" ok'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-174
    it "should fail if indented 4 or more spaces", (cb) ->
      test.markdown null, '    [foo]: /url "title"\n\n[foo]', [
        {type: 'document', nesting: 1}
        {type: 'preformatted', nesting: 1}
        {type: 'text', content: '[foo]: /url "title"'}
        {type: 'preformatted', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[foo]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-175
    it "should fail within code", (cb) ->
      test.markdown null, '```\n[foo]: /url\n```\n\n[foo]', [
        {type: 'document', nesting: 1}
        {type: 'code', nesting: 1}
        {type: 'text', content: '[foo]: /url'}
        {type: 'code', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[foo]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-176
    it "should not interrupt a paragraph", (cb) ->
      test.markdown null, 'Foo\n[bar]: /baz\n\n[bar]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'Foo'}
        {type: 'softbreak'}
        {type: 'text', content: '[bar]: /baz'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[bar]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-177
    it "should allow directly after block elements", (cb) ->
      test.markdown null, '# [Foo]\n[foo]: /url\n> bar', [
        {type: 'document', nesting: 1}
        {type: 'heading', nesting: 1}
        {type: 'link', nesting: 1, href: '/url'}
        {type: 'text', content: 'Foo'}
        {type: 'link', nesting: -1}
        {type: 'heading', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-178
    it "should allow multiple definitions after each other", (cb) ->
      test.markdown null, '[foo]: /foo-url "foo"\n[bar]: /bar-url\n  "bar"\n[baz]: /baz-url\n\n[foo],\n[bar],\n[baz]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/foo-url', title: 'foo'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'text', content: ','}
        {type: 'softbreak'}
        {type: 'link', nesting: 1, href: '/bar-url', title: 'bar'}
        {type: 'text', content: 'bar'}
        {type: 'link', nesting: -1}
        {type: 'text', content: ','}
        {type: 'softbreak'}
        {type: 'link', nesting: 1, href: '/baz-url'}
        {type: 'text', content: 'baz'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-179
    it "should allow inside blocks", (cb) ->
      test.markdown null, '[foo]\n\n> [foo]: /url', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'blockquote', nesting: 1}
        {type: 'blockquote', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

  describe "direct", ->

    # http://spec.commonmark.org/0.27/#example-456
    it "should parse simple link", (cb) ->
      test.markdown null, '[link](/uri "title")', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/uri', title: 'title'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-457
    it "should parse without title", (cb) ->
      test.markdown null, '[link](/uri)', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/uri'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-457
    # http://spec.commonmark.org/0.27/#example-458
    it "should allow without uri and title", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[link]()', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link](<>)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-460
    # http://spec.commonmark.org/0.27/#example-461
    # http://spec.commonmark.org/0.27/#example-462
    # http://spec.commonmark.org/0.27/#example-463
    it "should fail with whitespace in url", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[link](/my uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[link](/my uri)'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link](</my uri>)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[link](</my uri>)'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link](foo\nbar)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[link](foo'}
            {type: 'softbreak'}
            {type: 'text', content: 'bar)'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
  #      (cb) ->
  #        test.markdown null, '[link](<foo\nbar>)', [
  #          {type: 'document', nesting: 1}
  #          {type: 'paragraph', nesting: 1}
  #          {type: 'text', content: '[link](<foo'}
  #          {type: 'softbreak'}
  #          {type: 'text', content: 'bar>)'}
  #          {type: 'paragraph', nesting: -1}
  #          {type: 'document', nesting: -1}
  #        ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-464
    it "should allow escaped parenthesis in uri", (cb) ->
      test.markdown null, '[link](\\(foo\\))', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '(foo)'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-465
    it "should allow one level of balanced parenthesis", (cb) ->
      test.markdown null, '[link]((foo)and(bar))', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '(foo)and(bar)'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-466
    # http://spec.commonmark.org/0.27/#example-467
    # http://spec.commonmark.org/0.27/#example-468
    it "need escape or <...> for more nested parenthesis", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[link](foo(and(bar)))', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[link](foo(and(bar)))'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link](foo(and\\(bar\\)))', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: 'foo(and(bar))'}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link](<foo(and(bar))>)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: 'foo(and(bar))'}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-469
    it "should allow escaped parentheses", (cb) ->
      test.markdown null, '[link](foo\\)\\:)', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: 'foo):'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-470
    it "should allow fragments", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[link](#fragment)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '#fragment'}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link](http://example.com#fragment)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: 'http://example.com#fragment'}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link](http://example.com?foo=3#frag)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: 'http://example.com?foo=3#frag'}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-471
    it "should keep backslash for non escapable characters", (cb) ->
      test.markdown null, '[link](foo\\bar)', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: 'foo%5Cbar'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-472
    it "should keep url escapes", (cb) ->
      test.markdown null, '[link](foo%20b&auml;)', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: 'foo%20b%C3%A4'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-473
    it "should url can't be missing if title is present", (cb) ->
      test.markdown null, '[link]("title")', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '%22title%22'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-474
    it "should allow title with single, double quotes or parentheses", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[link](/url "title")', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link](/url \'title\')', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link](/url (title))', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'text', content: 'link'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-475
    it "should allow escapes and entities in title", (cb) ->
      test.markdown null, '[link](/url "title \\"&quot;")', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title \"\"'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-476
    it "should work with title separated by whitespace", (cb) ->
      test.markdown null, '[link](/url "title")', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-477
    it "should fail with nested, balanced quotes in title", (cb) ->
      test.markdown null, '[link](/url "title "and" title")', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[link](/url "title "and" title")'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-478
    it "should work with different quotes for nesting", (cb) ->
      test.markdown null, '[link](/url \'title "and" title\')', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title "and" title'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-479
    it "should allow whitespace arround url and title", (cb) ->
      test.markdown null, '[link](   /uri\n  "title"  )', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/uri', title: 'title'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-480
    it "should fail for whitespace between link text and following parentheses", (cb) ->
      test.markdown null, '[link] (/uri)', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[link] (/uri)'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-481
    # http://spec.commonmark.org/0.27/#example-482
    # http://spec.commonmark.org/0.27/#example-483
    # http://spec.commonmark.org/0.27/#example-484
    it "should allow only balanced brackets in link text", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[link [foo [bar]]](/uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'link [foo [bar]]'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link] bar](/uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[link] bar](/uri)'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link [bar](/uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[link '}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link \\[bar](/uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'link [bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-485
    # http://spec.commonmark.org/0.27/#example-486
    it "should allow markdown in link text", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[link *foo **bar** `#`*](/uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'link '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: ' '}
            {type: 'fixed', nesting: 1}
            {type: 'text', content: '#'}
            {type: 'fixed', nesting: -1}
            {type: 'emphasis', nesting: -1}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[![moon](moon.jpg)](/uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'image', nesting: 1, src: 'moon.jpg'}
            {type: 'text', content: 'moon'}
            {type: 'image', nesting: -1}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-487
    # http://spec.commonmark.org/0.27/#example-488
    # http://spec.commonmark.org/0.27/#example-489
    it "should fail for links in links", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo [bar](/uri)](/uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo '}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'bar'}
            {type: 'link', nesting: -1}
            {type: 'text', content: '](/uri)'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo *[bar [baz](/uri)](/uri)*](/uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: '[bar '}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'baz'}
            {type: 'link', nesting: -1}
            {type: 'text', content: '](/uri)'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: '](/uri)'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![[[foo](uri1)](uri2)](uri3)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: 'uri3'}
            {type: 'text', content: '['}
            {type: 'link', nesting: 1, href: 'uri1'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'text', content: '](uri2)'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-490
    # http://spec.commonmark.org/0.27/#example-491
    it "should have precedence over inline styles", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '*[foo*](/uri)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '*'}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'foo*'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo *bar](baz*)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: 'baz*'}
            {type: 'text', content: 'foo *bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-492
    it "should ignore brackets if not a link", (cb) ->
      test.markdown null, '*foo [bar* baz]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'emphasis', nesting: 1}
        {type: 'text', content: 'foo [bar'}
        {type: 'emphasis', nesting: -1}
        {type: 'text', content: ' baz]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

###########################################################################
# Missing because of html 493-495
###########################################################################

  describe "reference", ->

    # http://spec.commonmark.org/0.27/#example-496
    it "should allow simple", (cb) ->
      test.markdown null, '[foo][bar]\n\n[bar]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-497
    # http://spec.commonmark.org/0.27/#example-498
    it "should only allow balanced brackets in text", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[link [foo [bar]]][ref]\n\n[ref]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'link [foo [bar]]'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[link \\[bar][ref]\n\n[ref]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'link [bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-499
    # http://spec.commonmark.org/0.27/#example-500
    it "should allow inline elements", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[link *foo **bar** `#`*][ref]\n\n[ref]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'link '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo '}
            {type: 'strong', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'strong', nesting: -1}
            {type: 'text', content: ' '}
            {type: 'fixed', nesting: 1}
            {type: 'text', content: '#'}
            {type: 'fixed', nesting: -1}
            {type: 'emphasis', nesting: -1}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[![moon](moon.jpg)][ref]\n\n[ref]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'image', nesting: 1, src: 'moon.jpg'}
            {type: 'text', content: 'moon'}
            {type: 'image', nesting: -1}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-501
    # http://spec.commonmark.org/0.27/#example-502
    it "should not allow links in links", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo [bar](/uri)][ref]\n\n[ref]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo '}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'bar'}
            {type: 'link', nesting: -1}
            {type: 'text', content: ']'}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'ref'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo *bar [baz][ref]*][ref]\n\n[ref]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar '}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'baz'}
            {type: 'link', nesting: -1}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ']'}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'ref'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-503
    # http://spec.commonmark.org/0.27/#example-504
    it "should have precedence for link text", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '*[foo*][ref]\n\n[ref]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '*'}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'foo*'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo *bar][ref]\n\n[ref]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'foo *bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-505
    # http://spec.commonmark.org/0.27/#example-506
    # http://spec.commonmark.org/0.27/#example-507
    it "should not have precedence over html, fixed, autolinks", (cb) ->
      async.series [
############################
# html 505
############################
        (cb) ->
          test.markdown null, '[foo`][ref]`\n\n[ref]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo'}
            {type: 'fixed', nesting: 1}
            {type: 'text', content: '][ref]'}
            {type: 'fixed', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
############################
# html 507
############################
      ], cb

    # http://spec.commonmark.org/0.27/#example-508
    it "should work with case insensitive matching", (cb) ->
      test.markdown null, '[foo][BaR]\n\n[bar]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-509
    it "should match also unicode", (cb) ->
      test.markdown null, '[Толпой][Толпой] is a Russian word.\n\n[ТОЛПОЙ]: /url', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url'}
        {type: 'text', content: 'Толпой'}
        {type: 'link', nesting: -1}
        {type: 'text', content: ' is a Russian word.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-510
    it "should ignore whitespace in reference name", (cb) ->
      test.markdown null, '[Foo\n  bar]: /url\n\n[Baz][Foo bar]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url'}
        {type: 'text', content: 'Baz'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-511
    # http://spec.commonmark.org/0.27/#example-512
    it "should fail for whitespace in link text and label", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo] [bar]\n\n[bar]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo] '}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'text', content: 'bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo]\n[bar]\n\n[bar]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo]'}
            {type: 'softbreak'}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'text', content: 'bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-513
    it "should use first definition", (cb) ->
      test.markdown null, '[foo]: /url1\n\n[foo]: /url2\n\n[bar][foo]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url1'}
        {type: 'text', content: 'bar'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-514
    it "should match on normalized string", (cb) ->
      test.markdown null, '[bar][foo\\!]\n\n[foo!]: /url', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[bar][foo!]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-515
    # http://spec.commonmark.org/0.27/#example-516
    # http://spec.commonmark.org/0.27/#example-517
    # http://spec.commonmark.org/0.27/#example-518
    it "should only allow brackets in reference name if escaped", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo][ref[]\n\n[ref[]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo][ref[]'}
            {type: 'paragraph', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[ref[]: /uri'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo][ref[bar]]\n\n[ref[bar]]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo][ref[bar]]'}
            {type: 'paragraph', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[ref[bar]]: /uri'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[[[foo]]]\n\n[[[foo]]]: /url', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[[[foo]]]'}
            {type: 'paragraph', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[[[foo]]]: /url'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo][ref\\[]\n\n[ref\\[]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/uri'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-519
    it "should work with backslash in reference name", (cb) ->
      test.markdown null, '[bar\\\\]: /uri\n\n[bar\\\\]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/uri'}
        {type: 'text', content: 'bar\\'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-520
    # http://spec.commonmark.org/0.27/#example-521
    it "should only work if link label has at least one non whitespace", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[]\n\n[]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[]'}
            {type: 'paragraph', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[]: /uri'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[\n ]\n\n[\n ]: /uri', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '['}
            {type: 'softbreak'}
            {type: 'text', content: ']'}
            {type: 'paragraph', nesting: -1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '['}
            {type: 'softbreak'}
            {type: 'text', content: ']: /uri'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-522
    # http://spec.commonmark.org/0.27/#example-523
    it "should work with collapsed reference link", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo][]\n\n[foo]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[*foo* bar][]\n\n[*foo* bar]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-524
    it "should work with link label case insensitive", (cb) ->
      test.markdown null, '[Foo][]\n\n[foo]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'Foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-525
    it "should fail for whitespace between brackets", (cb) ->
      test.markdown null, '[foo] \n[]\n\n[foo]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'softbreak'}
        {type: 'text', content: '[]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-526
    # http://spec.commonmark.org/0.27/#example-527
    # http://spec.commonmark.org/0.27/#example-528
    # http://spec.commonmark.org/0.27/#example-529
    it "should allow shortcut for references", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo]\n\n[foo]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[*foo* bar]\n\n[*foo* bar]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[[*foo* bar]]\n\n[*foo* bar]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '['}
            {type: 'link', nesting: 1, href: '/url', title: 'title'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' bar'}
            {type: 'link', nesting: -1}
            {type: 'text', content: ']'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[[bar [foo]\n\n[foo]: /url', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[[bar '}
            {type: 'link', nesting: 1, href: '/url'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-530
    it "should allow case insensitive label names (shortcut)", (cb) ->
      test.markdown null, '[Foo]\n\n[foo]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'Foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-531
    it "should preserve space after link (shortcut)", (cb) ->
      test.markdown null, '[foo] bar\n\n[foo]: /url', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'text', content: ' bar'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-532
    it "should have normal text if escaped (shortcut)", (cb) ->
      test.markdown null, '\\[foo]\n\n[foo]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[foo]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-533
    it "should allow link if it ends with the first following closing bracket (shortcut)", (cb) ->
      test.markdown null, '[foo*]: /url\n\n*[foo*]', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '*'}
        {type: 'link', nesting: 1, href: '/url'}
        {type: 'text', content: 'foo*'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-534
    # http://spec.commonmark.org/0.27/#example-535
    it "should have precedence of full ans compact over shortcut version", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo][bar]\n\n[foo]: /url1\n[bar]: /url2', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url2'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo][]\n\n[foo]: /url1', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url1'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-536
    # http://spec.commonmark.org/0.27/#example-537
    it "should have precedence for inline links", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo]()\n\n[foo]: /url1', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: ''}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo](not a link)\n\n[foo]: /url1', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url1'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'text', content: '(not a link)'}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-538
    # http://spec.commonmark.org/0.27/#example-539
    # http://spec.commonmark.org/0.27/#example-540
    it "should work only for defined shortcuts", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '[foo][bar][baz]\n\n[baz]: /url', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo]'}
            {type: 'link', nesting: 1, href: '/url'}
            {type: 'text', content: 'bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo][bar][baz]\n\n[baz]: /url1\n[bar]: /url2', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'link', nesting: 1, href: '/url2'}
            {type: 'text', content: 'foo'}
            {type: 'link', nesting: -1}
            {type: 'link', nesting: 1, href: '/url1'}
            {type: 'text', content: 'baz'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '[foo][bar][baz]\n\n[baz]: /url1\n[foo]: /url2', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: '[foo]'}
            {type: 'link', nesting: 1, href: '/url1'}
            {type: 'text', content: 'bar'}
            {type: 'link', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb
