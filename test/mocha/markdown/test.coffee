chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
async = require 'async'
fs = require 'fs'
util = require 'alinex-util'
Report = require '../../../src'

module.exports =

  success: (id, input, data, format, cb) ->
    id = __dirname + "/../../../src/examples/#{id}" if id
    report = new Report()
    debug 'IN', util.inspect input
    fs.writeFileSync "#{id}.source", input if id and process.env.EXAMPLES
    report.markdown input
    parsed = util.clone report.parser.tokens
    .map (e) ->
      delete e.parent
      e
    tokenList = util.inspect(parsed, {depth: 2})
    .replace /\s*\n\s*/g, ' '
    .replace /(\{ type:)/g, '\n$1'
    debug 'PARSED tokens', tokenList
    fs.writeFileSync "#{id}.tokens", tokenList if id and process.env.EXAMPLES
    if data
      expect(report.parser.tokens.length, 'num tokens').to.equal data.length
      for token, num in data
        for k, v of token
          expect(report.parser.tokens[num][k], "data[#{num}].#{k}").to.deep.equal v
    return cb null, report unless format
    async.eachSeries format, (test, cb) ->
      report.format
        format: test.format
      , (err, name) ->
        debug 'OUT', name, util.inspect report.output(name), {depth: 2}
        fs.writeFileSync "#{id}.#{name}", report.output(name) if id and process.env.EXAMPLES
        expect(err, 'format exception').to.not.exist
        if test.re
          expect(report.output(name), "#{name} output").to.match test.re
        else if test.text
          expect(report.output(name), "#{name} output").to.contain test.text
        cb()
    , cb

  fail: (input, data) ->
    ok = true
    report = new Report()
    debug 'IN', util.inspect input
    report.markdown input
    debug 'OUT', util.inspect report.parser.tokens, {depth: 2}
    if data
      ok = false if report.parser.tokens.length isnt data.length
      for token, num in data
        for k, v of token
          ok = false if report.parser.tokens[num][k] isnt v
      expect(ok).to.equal false
    report
