chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
util = require 'util'
parser = require '../../../src/parser'

module.exports = (input, data) ->
  out = parser input, 'm'
  debug util.inspect out, {depth: 1}
  return out unless data
  expect(out.length, 'num tokens').to.equal data.length
  for num, token in data
    for k, v of token
      expect(out[num][k], "data[#{num}].#{k}").to.equal v
  out
