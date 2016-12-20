chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
util = require 'util'
parser = require '../../../../src/parser'
test = require './test'

describe "parser", ->

  describe "markdown", ->

    describe "heading", ->

      it "should work with ATX level 1", ->
        test.success '# foo', [
          type: 'heading'
          data:
            level: 1
          nesting: 1
        ,
          type: 'text'
          data:
            text: 'foo'
        ,
          type: 'heading'
          data:
            level: 1
          nesting: -1
        ]
      it "should work with ATX level 2", ->
        test.success '## foo', [
          type: 'heading'
          data:
            level: 2
          nesting: 1
        ,
          type: 'text'
          data:
            text: 'foo'
        ,
          type: 'heading'
          data:
            level: 2
          nesting: -1
        ]
      it "should work with ATX level 3", ->
        test.success '### foo', [
          type: 'heading'
          data:
            level: 3
          nesting: 1
        ,
          type: 'text'
          data:
            text: 'foo'
        ,
          type: 'heading'
          data:
            level: 3
          nesting: -1
        ]
      it "should work with ATX level 4", ->
        test.success '#### foo', [
          type: 'heading'
          data:
            level: 4
          nesting: 1
        ,
          type: 'text'
          data:
            text: 'foo'
        ,
          type: 'heading'
          data:
            level: 4
          nesting: -1
        ]
      it "should work with ATX level 5", ->
        test.success '##### foo', [
          type: 'heading'
          data:
            level: 5
          nesting: 1
        ,
          type: 'text'
          data:
            text: 'foo'
        ,
          type: 'heading'
          data:
            level: 5
          nesting: -1
        ]
      it "should work with ATX level 6", ->
        test.success '###### foo', [
          type: 'heading'
          data:
            level: 6
          nesting: 1
        ,
          type: 'text'
          data:
            text: 'foo'
        ,
          type: 'heading'
          data:
            level: 6
          nesting: -1
        ]

      it "should fail with more than 6 # characters", ->
        test.success '####### foo', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]

      it "should fail if the space after # characters is missing", ->
        test.success '#5 bolt', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]
        test.success '#hashtag', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]

      it "should fail if the first # characters is escaped", ->
        test.success '\\## foo', [{type: 'paragraph'}, {type: 'text'}, {type: 'paragraph'}]


#Contents are parsed as inlines:
#Example 36Try It
#
## foo *bar* \*baz\*
#
#<h1>foo <em>bar</em> *baz*</h1>

      it "should work with more leading or trailing spaces", ->
        test.success '#       foo', [
          type: 'heading'
          data:
            level: 1
          nesting: 1
        ,
          type: 'text'
          data:
            text: 'foo'
        ,
          type: 'heading'
          data:
            level: 1
          nesting: -1
        ]
        test.success '#       foo          ', [
          type: 'heading'
          data:
            level: 1
          nesting: 1
        ,
          type: 'text'
          data:
            text: 'foo'
        ,
          type: 'heading'
          data:
            level: 1
          nesting: -1
        ]
