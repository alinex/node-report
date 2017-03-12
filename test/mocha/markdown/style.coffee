### eslint-env node, mocha ###
test = require '../test'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "style", ->

  describe "markdown", ->

    it "should add block", (cb) ->
      test.markdown null, "aaa\n\n<!-- {.red} -->", [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'aaa'}
        {type: 'paragraph', nesting: -1}
        {type: 'style', nesting: 0, content: '.red'}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should add inline", (cb) ->
      test.markdown null, "aaa<!-- {.red} -->", [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'aaa'}
        {type: 'style', nesting: 0, content: '.red'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
