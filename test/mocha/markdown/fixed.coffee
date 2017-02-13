### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown fixed", ->

  # http://spec.commonmark.org/0.27/#example-286
  it "should parse inline sequentially", (cb) ->
    test.markdown null, '`hi`lo`', [
      {type: 'document', nesting: 1}
      {type: 'paragraph', nesting: 1}
      {type: 'fixed', nesting: 1}
      {type: 'text', content: 'hi'}
      {type: 'fixed', nesting: -1}
      {type: 'text', content: 'lo`'}
      {type: 'paragraph', nesting: -1}
      {type: 'document', nesting: -1}
    ], null, cb
