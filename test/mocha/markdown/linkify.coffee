### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown linkify", ->

  it "should allow direct links", (cb) ->
    test.markdown null, 'http://foo.com', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'link', nesting: 1, href: 'http://foo.com'}
      {type: 'text', content: 'http://foo.com'}
      {type: 'link', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should allow ip addresses", (cb) ->
    test.markdown null, 'http://192.168.1.1', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'link', nesting: 1, href: 'http://192.168.1.1'}
      {type: 'text', content: 'http://192.168.1.1'}
      {type: 'link', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

  it "should allow mailto links", (cb) ->
    test.markdown null, 'bar@foo.com', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'link', nesting: 1, href: 'mailto:bar@foo.com'}
      {type: 'text', content: 'bar@foo.com'}
      {type: 'link', nesting: -1}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb

#  it "should allow fuzzy links", (cb) ->
#    test.markdown null, 'google.com', [
#      {type: 'document', nesting: 1}
#      {type: 'paragraph', nesting: 1}
#      {type: 'link', nesting: 1, href: 'http://google.com'}
#      {type: 'text', content: 'google.com'}
#      {type: 'link', nesting: -1}
#      {type: 'paragraph', nesting: -1}
#      {type: 'document', nesting: -1}
#    ], null, cb
