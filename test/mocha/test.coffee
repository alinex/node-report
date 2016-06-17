chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
async = require 'async'
fs = require 'fs'

debug = require('debug')('test:examples')

exports.report = (name, report, md, html, cb) ->
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
