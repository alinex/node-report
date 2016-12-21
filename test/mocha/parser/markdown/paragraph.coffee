### eslint-env node, mocha ###
test = require './test'

describe "parser", ->

  describe "markdown", ->

    describe "paragraph", ->

      it "should work with single line paragraphs", ->
        test.success 'aaa\n\nbbb', [
          type: 'paragraph'
        ,
          type: 'text'
          data:
            text: 'aaa'
        ,
          type: 'paragraph'
        ,
          type: 'paragraph'
        ,
          type: 'text'
          data:
            text: 'bbb'
        ,
          type: 'paragraph'
        ]

      it "should work with mulziple lines in paragraph", ->
        test.success 'aaa\nbbb\n\nccc\nddd', [
          type: 'paragraph'
        ,
          type: 'text'
          data:
            text: 'aaa\nbbb'
        ,
          type: 'paragraph'
        ,
          type: 'paragraph'
        ,
          type: 'text'
          data:
            text: 'ccc\nddd'
        ,
          type: 'paragraph'
        ]
