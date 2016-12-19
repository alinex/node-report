chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
util = require 'util'
parser = require '../../../../src/parser'
test = require '../test'

describe "parser", ->

  describe "markdown", ->

    it "should get heading level 1", ->
      test '# Text **15** Number 6', [
        type: 'heading'
        data: 1
        nesting: 1
      ,
        type: 'text'
        data: 'Text **15** Number 6'
      ,
        type: 'heading'
        data: 1
        nesting: -1
      ]
