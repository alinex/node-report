chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
util = require 'util'
parser = require '../../../../src/parser'
test = require './test'

describe "parser", ->

  describe "markdown", ->

    describe "text", ->

      it.skip "should remove backslash before initial # character", ->
        test.success '\\## foo', [
          type: 'paragraph'
        ,
          type: 'text'
          data:
            text: '## foo'
        ,
          type: 'paragraph'
        ]
