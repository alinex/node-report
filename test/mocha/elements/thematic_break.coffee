### eslint-env node, mocha ###
test = require '../test'

describe "parser", ->

  describe "markdown", ->

    describe.skip "thematic break", ->

      it "should work with three characters", ->
        test.success '***', [type: 'thematic_break']
        test.success '---', [type: 'thematic_break']
        test.success '___', [type: 'thematic_break']

      it "should fail with wrong characters", ->
        test.success '+++', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]
        test.success '===', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]

      it "should fail with not enough characters", ->
        test.success '--', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]
        test.success '**', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]
        test.success '__', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]

      it "should work with one to three spaces indent", ->
        test.success ' ***', [type: 'thematic_break']
        test.success '  ***', [type: 'thematic_break']
        test.success '   ***', [type: 'thematic_break']

      it "should fail with four spaces indent", ->
        test.fail '    ***', [type: 'thematic_break']

      it "should work with more than three characters", ->
        test.success '_____________________________________', [type: 'thematic_break']

      it "should work with spaces between the characters", ->
        test.success ' - - -', [type: 'thematic_break']
        test.success ' **  * ** * ** * **', [type: 'thematic_break']
        test.success '-     -      -      -', [type: 'thematic_break']

      it "should work with spaces at the end", ->
        test.success '- - - -    ', [type: 'thematic_break']

      it "should fail with other characters within the line", ->
        test.success '_ _ _ _ a', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]
        test.success 'a------', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]
        test.success '---a---', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]

      it "should fail with different line characters", ->
        test.success ' *-*', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]

      it "should work without blank lines before and after", ->
        test.success "foo\n***\nbar", [
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'foo'}}
          {type: 'paragraph', nesting: -1}
          {type: 'thematic_break'}
          {type: 'paragraph', nesting: 1}
          {type: 'text', data: {text: 'bar'}}
          {type: 'paragraph', nesting: -1}
        ]

#If a line of dashes that meets the above conditions for being a thematic break could also be interpreted as the underline of a setext heading, the interpretation as a setext heading takes precedence. Thus, for example, this is a setext heading, not a paragraph followed by a thematic break:
#Example 29Try It
#
#Foo
#---
#bar
#
#
#
#When both a thematic break and a list item are possible interpretations of a line, the thematic break takes precedence:
#Example 30Try It
#
#* Foo
#* * *
#* Bar
#
#<ul>
#<li>Foo</li>
#</ul>
#<hr />
#<ul>
#<li>Bar</li>
#</ul>
#
#If you want a thematic break in a list item, use a different bullet:
#Example 31Try It
#
#- Foo
#- * * *
#
#<ul>
#<li>Foo</li>
#<li>
#<hr />
