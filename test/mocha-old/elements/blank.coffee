### eslint-env node, mocha ###
test = require '../test'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "blank", ->

  describe "markdown", ->

    # http://spec.commonmark.org/0.27/#example-188
    it "should ignore blank lines at beginning and end", (cb) ->
      test.markdown null, "\n  \naaa\n  \n# bbb\n  \n", [
        {type: 'document', nesting: 1}
        {type: 'paragraph'}
        {type: 'text', data: {text: 'aaa'}}
        {type: 'paragraph'}
        {type: 'heading'}
        {type: 'text', data: {text: 'bbb'}}
        {type: 'heading'}
        {type: 'document', nesting: -1}
      ], null, cb
