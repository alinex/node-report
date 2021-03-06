chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug') 'test'
chalk = require 'chalk'
async = require 'async'
fspath = require 'path'
util = require 'alinex-util'
fs = require 'alinex-fs'
Config = require 'alinex-config'

Report = require '../../src'

EXAMPLES_DIR = 'src/examples'
ALL_FORMATS = [
  {format: 'md'}
  {format: 'text'}
  {format: 'console'}
  {format: 'html'}
  {format: 'html2png'}
#  {format: 'html2jpg'}
#  {format: 'html2pdf'}
  {format: 'man'}
]

module.exports =

  markdown: (id, input, data, format, cb) ->
    debug 'IN', chalk.bold.yellow util.inspect input, {depth: 2}
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
        debug 'reparse markdown', chalk.yellow util.inspect result
        copy = new Report()
        copy.markdown result
        expect(copy.tokens.data, 'format+parse without change').to.be.deep.equal report.tokens.data
        cb()

  report: (id, report, data, format, cb) ->
    if id and process.env.EXAMPLES
      example = __dirname + "/../../#{EXAMPLES_DIR}/#{id}"
      fs.mkdirsSync fspath.dirname example
    fs.writeFileSync "#{example}.tokens.js", util.inspect report.tokens if example
    if data
      expect(report.tokens.data.length, 'num tokens').to.equal data.length
      for token, num in data
        for k, v of token
          expect(report.tokens.data[num][k], "data[#{num}].#{k}").to.deep.equal v
    return cb null, report unless format
    format = ALL_FORMATS if format is true
    async.eachSeries format, (test, cb) ->
      report.format test.format, (err, result) ->
        return cb err if err
        debug 'OUT', test.format, if test.format.match /html2/
          "BINARY #{result.length} bytes"
        else if test.format is 'html'
          util.inspect result.replace /^[\s\S]+<\/head>\s+/, ''
        else
          util.inspect result, {depth: 2}
        config = Config.get "/report/format/#{test.format}"
        ext = config.extension ? ".#{test.format}"
        if example
          fs.writeFileSync "#{example}#{ext}", result,
            encoding: if config.convert then 'binary' else 'utf8'
        expect(err, 'format exception').to.not.exist
        if test.re
          expect(result, "#{test.format} output").to.match test.re
        else if test.text
          expect(result, "#{test.format} output").to.contain test.text
        cb()
    , cb
