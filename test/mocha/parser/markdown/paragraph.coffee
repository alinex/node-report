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

      it "should work with multiple blank lines in paragraph", ->
        test.success 'aaa\n\n\nbbb', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'aaa'}}
          {type: 'paragraph', nesting: -1}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'bbb'}}
          {type: 'paragraph', nesting: -1}
        ]

      it "should work with 1-3 leading spaces ignored", ->
        test.success '  aaa\n bbb', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'aaa\nbbb'}}
          {type: 'paragraph', nesting: -1}
        ]
        test.success '   aaa\nbbb', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'aaa\nbbb'}}
          {type: 'paragraph', nesting: -1}
        ]

      it "should work with multiple leading spaces after the first line", ->
        test.success 'aaa\n             bbb\n                                       ccc', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'aaa\nbbb\nccc'}}
          {type: 'paragraph', nesting: -1}
        ]

#However, the first line may be indented at most three spaces, or an indented code block will be triggered:
#Example 186Try It
#
#    aaa
#bbb
#
#<pre><code>aaa
#</code></pre>
#<p>bbb</p>

      it "should work with line break if two or more spaces", ->
        test.success 'aaa     \nbbb     ', [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'aaa\\\nbbb'}}
          {type: 'paragraph', nesting: -1}
        ]
