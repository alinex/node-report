chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
util = require 'util'
parser = require '../../src/parser'

testParse = (input, num) ->
  out = parser input
  if num
    expect(out.length, 'num tokens').to.equal num
  debug util.inspect out, {depth: 1}
  out

describe "parser", ->

  describe "test", ->

    it "should work", ->
      tokens = testParse '# Text **15** Number 6', 3
      expect(tokens[0].type).is.equal 'heading'
      expect(tokens[0].data).is.equal 1
      expect(tokens[0].nesting).is.equal 1
      expect(tokens[1].type).is.equal 'text'
      expect(tokens[1].data).is.equal 'Text **15** Number 6'
      expect(tokens[2].type).is.equal 'heading'
      expect(tokens[2].data).is.equal 1
      expect(tokens[2].nesting).is.equal -1
