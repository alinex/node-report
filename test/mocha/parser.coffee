chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
util = require 'util'
parser = require '../../src/parser'

test = (input, num) ->
  out = parser input
  if num
    expect(out.length, 'num tokens').to.equal num
  debug util.inspect out, {depth: 1}
  out

describe "parser", ->

  describe "test", ->

    it "should work", ->
      test '# Text **15** Number 6', 3
