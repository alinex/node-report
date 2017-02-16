### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe.only "markdown link", ->

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
  it.only "should allow markdown in link text", (cb) ->
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
