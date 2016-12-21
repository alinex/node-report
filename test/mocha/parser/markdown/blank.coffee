### eslint-env node, mocha ###
test = require './test'

describe "parser", ->

  describe "markdown", ->

    describe "blank", ->

      it "should ignore blank lines at beginnin and end", ->
        test.success '\n  \naaa\n  \n# bbb\n  \n', [
          type: 'paragraph'
        ,
          type: 'text'
          data:
            text: 'aaa'
        ,
          type: 'paragraph'
        ,
          type: 'heading'
        ,
          type: 'text'
          data:
            text: 'bbb'
        ,
          type: 'heading'
        ]
