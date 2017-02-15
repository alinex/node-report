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
