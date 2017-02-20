### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "markdown images", ->

  describe "direct", ->

    # http://spec.commonmark.org/0.27/#example-456
    it "should parse simple link", (cb) ->
      test.markdown null, '<!-- xxx -->', [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/uri', title: 'title'}
        {type: 'text', content: 'link'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
