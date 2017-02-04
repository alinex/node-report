chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
async = require 'async'
fspath = require 'path'
util = require 'alinex-util'
fs = require 'alinex-fs'
Report = require '../../src'

EXAMPLES_DIR = 'src/examples'

module.exports =

  markdown: (id, input, data, format, cb) ->
    report = new Report()
    if id and process.env.EXAMPLES
      example = __dirname + "/../../#{EXAMPLES_DIR}/#{id}"
      fs.mkdirsSync fspath.dirname example
      fs.writeFileSync "#{example}.source.md", input
    report.markdown input
    module.exports.report id, report, data, format, (err) ->
      return cb err if err
      # check formatting and reparsing
      report.format 'md', (err, result) ->
        return cb err if err
        copy = new Report()
        copy.markdown result
        expect(result.tokens, 'format+parse without change').to.be.deep.equal copy.tokens
        cb()

  report: (id, report, data, format, cb) ->
    if id and process.env.EXAMPLES
      example = __dirname + "/../../#{EXAMPLES_DIR}/#{id}"
      fs.mkdirsSync fspath.dirname example
    fs.writeFileSync "#{example}.tokens.js", report.tokens if example
    if data
      expect(report.tokens.data.length, 'num tokens').to.equal data.length
      for token, num in data
        for k, v of token
          expect(report.tokens.data[num][k], "data[#{num}].#{k}").to.deep.equal v
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
