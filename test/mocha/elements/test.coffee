chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
async = require 'async'
fspath = require 'path'
util = require 'alinex-util'
fs = require 'alinex-fs'
Report = require '../../../src'

module.exports =

  markdown: (id, input, data, format, cb) ->
    report = new Report()
    debug 'IN', util.inspect input
    if id and process.env.EXAMPLES
      example = __dirname + "/../../../src/elements/#{id}"
      fs.mkdirsSync fspath.dirname example
      fs.writeFileSync "#{example}.source", input
    report.markdown input
    module.exports.report id, report, data, format, cb

  report: (id, report, data, format, cb) ->
    if id and process.env.EXAMPLES
      example = __dirname + "/../../../src/elements/#{id}"
      fs.mkdirsSync fspath.dirname example
    report.parser.end()
    parsed = util.clone report.parser.tokens
    .map (e) ->
      delete e.parent
      e
    tokenList = util.inspect(parsed, {depth: 2})
    .replace /\s*\n\s*/g, ' '
    .replace /(\{ type:)/g, '\n$1'
    debug 'TOKENS', tokenList
    fs.writeFileSync "#{example}.tokens", tokenList if example
    if data
      expect(report.parser.tokens.length, 'num tokens').to.equal data.length
      for token, num in data
        for k, v of token
          expect(report.parser.tokens[num][k], "data[#{num}].#{k}").to.deep.equal v
    return cb null, report unless format
    async.eachSeries format, (test, cb) ->
      report.format test.format, (err, result) ->
        return cb err if err
        debug 'OUT', test.format, util.inspect result, {depth: 2}
        fs.writeFileSync "#{example}.#{test.format}", result if example
        expect(err, 'format exception').to.not.exist
        if test.re
          expect(result, "#{test.format} output").to.match test.re
        else if test.text
          expect(result, "#{test.format} output").to.contain test.text
        cb()
    , cb
