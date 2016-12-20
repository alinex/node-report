chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
util = require 'util'
Parser = require '../../../src/parser'

module.exports = (input, data) ->
  parser = new Parser input, 'm'
  parser.parse()
  debug util.inspect parser.tokens, {depth: 1}
  return parser.tokens unless data
  expect(parser.tokens.length, 'num tokens').to.equal data.length
  for num, token in data
    for k, v of token
      expect(parser.tokens[num][k], "data[#{num}].#{k}").to.equal v
  parser.tokens
