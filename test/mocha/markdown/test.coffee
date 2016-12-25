chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
util = require 'util'
Parser = require '../../../src/parser'

module.exports =

  success: (input, data) ->
    parser = new Parser input, 'm'
    debug 'IN', util.inspect input
    parser.parse()
    debug 'OUT', util.inspect parser.tokens, {depth: 2}
    return parser.tokens unless data
    expect(parser.tokens.length, 'num tokens').to.equal data.length
    for token, num in data
      for k, v of token
        expect(parser.tokens[num][k], "data[#{num}].#{k}").to.deep.equal v
    parser

  fail: (input, data) ->
    ok = true
    parser = new Parser input, 'm'
    debug 'IN', util.inspect input
    parser.parse()
    debug 'OUT', util.inspect parser.tokens, {depth: 2}
    return parser.tokens unless data
    ok = false if parser.tokens.length isnt data.length
    for token, num in data
      for k, v of token
        ok = false if parser.tokens[num][k] isnt v
    expect(ok).to.equal false
    parser

  markdown: (name, parser, re) ->
  console: (name, parser, re) ->
  log: (name, parser, re) ->
  html: (name, parser, re) ->
