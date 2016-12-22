### eslint-env node, mocha ###
test = require './test'

describe "parser", ->

  describe "markdown", ->

    describe "paragraph", ->

      it "should work with single line paragraphs", ->
        test.success 'aaa\n\nbbb', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'aaa'}}
          {type: 'paragraph', nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'bbb'}}
          {type: 'paragraph', nesting: -1}
        ]

      it "should work with multiple lines in paragraph", ->
        test.success 'aaa\nbbb\n\nccc\nddd', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'aaa\nbbb'}}
          {type: 'paragraph', nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'ccc\nddd'}}
          {type: 'paragraph', nesting: -1}
        ]

#
#Multiple blank lines between paragraph have no effect:
#Example 182Try It
#
#aaa
#
#
#bbb
