### eslint-env node, mocha ###
async = require 'async'
fs = require 'fs'

debug = require('debug')('test:examples')
Report = require '../../../src/index'

create = (name, report, cb) ->
  async.parallel [
    (cb) ->
      fd = fs.createWriteStream "#{__dirname}/../../../src/doc/elements/#{name}.md"
      fd.write report.toString()
      fd.end()
      debug "create #{name}.md"
      cb()
    (cb) ->
      report.toHtml (err, data) ->
        fd = fs.createWriteStream "#{__dirname}/../../../src/doc/elements/#{name}.html"
        fd.write data
        fd.end()
        debug "create #{name}.html"
        cb()
    (cb) ->
      report.toImage (err, data) ->
        fd = fs.createWriteStream "#{__dirname}/../../../src/doc/elements/#{name}.png"
        fd.write data
        fd.end()
        debug "create #{name}.png"
        cb()
  ], cb


describe.only "examples", ->
  @timeout 5000

  it "should create headings", (cb) ->
    report = new Report()
    report.h1 "h1 Heading"
    report.h2 "h2 Heading"
    report.h3 "h3 Heading"
    report.h4 "h4 Heading"
    report.h5 "h5 Heading"
    report.h6 "h6 Heading"
    create 'headings', report, cb

  it "should create paragraph", (cb) ->
    report = new Report()
    report.p 'A new paragraph.'
    report.p 'A long text may be automatically broken into multiple lines.', 40
    report.p 'And here comes a fixed\n linebreak.\n\nWith a second paragraph.'
    create 'paragraph', report, cb

  it "should create quote", (cb) ->
    report = new Report()
    report.quote 'My home is my castle!'
    report.quote "I would like to visit a castle in north scotland, next year.", 2, 40
    create 'quote', report, cb

  it "should create code", (cb) ->
    report = new Report()
    report.code 'var x = Math.round(f);', 'js'
    report.code 'This **is** a ==markdown== text', 'markdown'
    report.code 'simple:\n  list: ["a", b, 5]', 'yaml'
    create 'code', report, cb
