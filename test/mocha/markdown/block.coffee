### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe.only "markdown block", ->

  describe "single box", ->

    it "should allow simple", (cb) ->
      test.markdown null, """
        ::: info title
        foo
        :::
        """, [
        {type: 'document', nesting: 1}
        {type: 'dl', nesting: 1}
        {type: 'dt', nesting: 1}, {type: 'text', content: 'Term 1'}, {type: 'dt', nesting: -1}
        {type: 'dd', nesting: 1}
        {type: 'paragraph', nesting: 1}, {type: 'text', content: 'Definition 1'}, {type: 'paragraph', nesting: -1}
        {type: 'dd', nesting: -1}
        {type: 'dl', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
