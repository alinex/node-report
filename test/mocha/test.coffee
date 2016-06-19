chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
async = require 'async'
fs = require 'fs'
chalk = require 'chalk'

debug = require('debug')('test:examples')

exports.report = (name, report, md, html, cb) ->
  exports.toText name, report
  exports.toConsole name, report
  async.parallel [
    (cb) ->
      data = report.toString()
      if md
        debug "check markdown"
        expect(data, 'markdown').to.equal md
      return cb() unless name and process.env.EXAMPLES
      fd = fs.createWriteStream "#{__dirname}/../../src/doc/#{name}.md"
      fd.write data
      fd.end()
      debug "created #{name}.md"
      cb()
    (cb) ->
      report.toHtml (err, data) ->
        if html
          debug "check html"
          expect(data, 'html').to.contain html
        return cb() unless name and process.env.EXAMPLES
        fd = fs.createWriteStream "#{__dirname}/../../src/doc/#{name}.html"
        fd.write data
        fd.end()
        debug "created #{name}.html"
        cb()
    (cb) ->
      return cb() unless name and process.env.EXAMPLES
      report.toImage (err, data) ->
        fd = fs.createWriteStream "#{__dirname}/../../src/doc/#{name}.png"
        fd.write data
        fd.end()
        debug "created #{name}.png"
        cb()
  ], cb

exports.toText = (name, report) ->
  unless process.env.EXAMPLES
    return report.toText()
  console.log chalk.inverse "#{name} Converted to Text"
  console.log report.toText()

exports.toConsole = (name, report) ->
  unless process.env.EXAMPLES
    return report.toConsole()
  console.log chalk.inverse "#{name} Converted to Console Output"
  console.log report.toConsole()
