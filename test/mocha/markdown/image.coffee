### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown images", ->

  describe "direct", ->

    # http://spec.commonmark.org/0.27/#example-541
    # http://spec.commonmark.org/0.27/#example-542
    # http://spec.commonmark.org/0.27/#example-543
    # http://spec.commonmark.org/0.27/#example-544
    it "should parse simple image", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '![foo](/url "title")', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url', title: 'title'}
            {type: 'text', content: 'foo'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![foo *bar*]\n\n[foo *bar*]: train.jpg "train & tracks"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: 'train.jpg', title: 'train & tracks'}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![foo ![bar](/url)](/url2)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url2'}
            {type: 'text', content: 'foo '}
            {type: 'image', nesting: 1, src: '/url'}
            {type: 'text', content: 'bar'}
            {type: 'image', nesting: -1}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![foo [bar](/url)](/url2)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url2'}
            {type: 'text', content: 'foo '}
            {type: 'link', nesting: 1, href: '/url'}
            {type: 'text', content: 'bar'}
            {type: 'link', nesting: -1}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-545
    # http://spec.commonmark.org/0.27/#example-546
    # http://spec.commonmark.org/0.27/#example-547
    # http://spec.commonmark.org/0.27/#example-548
    # http://spec.commonmark.org/0.27/#example-549
    # http://spec.commonmark.org/0.27/#example-550
    it "should have markdown in alt text which is hold back in html output", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '![foo *bar*][]\n\n[foo *bar*]: train.jpg "train & tracks"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: 'train.jpg', title: 'train & tracks'}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![foo *bar*][foobar]\n\n[FOOBAR]: train.jpg "train & tracks"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: 'train.jpg', title: 'train & tracks'}
            {type: 'text', content: 'foo '}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'bar'}
            {type: 'emphasis', nesting: -1}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![foo](train.jpg)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: 'train.jpg'}
            {type: 'text', content: 'foo'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, 'My ![foo bar](/path/to/train.jpg  "title"   )', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'text', content: 'My '}
            {type: 'image', nesting: 1, src: '/path/to/train.jpg', title: 'title'}
            {type: 'text', content: 'foo bar'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![foo](<url>)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: 'url'}
            {type: 'text', content: 'foo'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![](/url)', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-551
    # http://spec.commonmark.org/0.27/#example-552
    it "should allow reference style", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '![foo][bar]\n\n[bar]: /url', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url'}
            {type: 'text', content: 'foo'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![foo][bar]\n\n[BAR]: /url', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url'}
            {type: 'text', content: 'foo'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-553
    # http://spec.commonmark.org/0.27/#example-554
    it "should allow collapsed style", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '![foo][]\n\n[foo]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url', title: 'title'}
            {type: 'text', content: 'foo'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![*foo* bar][]\n\n[*foo* bar]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url', title: 'title'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' bar'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-555
    it "should be case insensitive for labels", (cb) ->
      test.markdown null, '![Foo][]\n\n[foo]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'image', nesting: 1, src: '/url', title: 'title'}
        {type: 'text', content: 'Foo'}
        {type: 'image', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-556
    it "should fail for whitespace between brackets", (cb) ->
      test.markdown null, '![foo] \n[]\n\n[foo]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'image', nesting: 1, src: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'image', nesting: -1}
        {type: 'softbreak'}
        {type: 'text', content: '[]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-557
    # http://spec.commonmark.org/0.27/#example-558
    it "should allow shortcut style", (cb) ->
      async.series [
        (cb) ->
          test.markdown null, '![foo]\n\n[foo]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url', title: 'title'}
            {type: 'text', content: 'foo'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
        (cb) ->
          test.markdown null, '![*foo* bar]\n\n[*foo* bar]: /url "title"', [
            {type: 'document', nesting: 1}
            {type: 'paragraph', nesting: 1}
            {type: 'image', nesting: 1, src: '/url', title: 'title'}
            {type: 'emphasis', nesting: 1}
            {type: 'text', content: 'foo'}
            {type: 'emphasis', nesting: -1}
            {type: 'text', content: ' bar'}
            {type: 'image', nesting: -1}
            {type: 'paragraph', nesting: -1}
            {type: 'document', nesting: -1}
          ], null, cb
      ], cb

    # http://spec.commonmark.org/0.27/#example-559
    it "should fail for labels with unescaped brackets", (cb) ->
      test.markdown null, '![[foo]]\n\n[[foo]]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '![[foo]]'}
        {type: 'paragraph', nesting: -1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '[[foo]]: /url "title"'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-560
    it "should allow link labels case insensitive", (cb) ->
      test.markdown null, '![Foo]\n\n[foo]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'image', nesting: 1, src: '/url', title: 'title'}
        {type: 'text', content: 'Foo'}
        {type: 'image', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-561
    it "should prevent image with escapes", (cb) ->
      test.markdown null, '\\!\\[foo]\n\n[foo]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '![foo]'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    # http://spec.commonmark.org/0.27/#example-562
    it "should allow link after exclamation mark", (cb) ->
      test.markdown null, '\\![foo]\n\n[foo]: /url "title"', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: '!'}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
