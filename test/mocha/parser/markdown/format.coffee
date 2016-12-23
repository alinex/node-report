### eslint-env node, mocha ###
test = require './test'

describe "parser", ->

  describe "markdown", ->

    describe "format", ->

      it.skip "should detect code element", ->
        test.success '`hi`lo`', [
          {type: 'paragraph', nesting: 1}
          {type: 'code', nesting: 1}
          {type: 'text', data: {text: 'hi'}}
          {type: 'code', nesting: -1}
          {type: 'text', data: {text: 'lo`'}}
          {type: 'paragraph', nesting: -1}
        ]
