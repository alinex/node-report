### eslint-env node, mocha ###
test = require './test'

describe "parser", ->

  describe "markdown", ->

    describe "text", ->

      it.skip "should remove backslash before initial # character", ->
        test.success '\\## foo', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: '## foo'}}
          {type: 'paragraph', nesting: -1}
        ]
