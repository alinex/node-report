### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown linkify", ->

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
