chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

debug = require('debug')('test:image')
Report = require '../../src/index'
path = require 'path'
fs = require 'fs'

equal = (a, b) ->
  debug "result", a
#  console.log util.inspect a
#  console.log util.inspect b
  expect(a, 'result').to.equal b

describe "image", ->

  describe "inline", ->

    it "should add an external image", ->
      equal Report.img("google", "http://google.de/favicon.ico"),
        "![google](http://google.de/favicon.ico)"

    it "should add an external image with title", ->
      equal Report.img("google", "http://google.de/favicon.ico", 'Google Logo'),
        "![google](http://google.de/favicon.ico \"Google Logo\")"

    it "should add a local image", ->
      equal Report.img("alinex", "file://#{path.dirname __dirname}/data/alinex.png"),
        "![alinex](file://#{path.dirname __dirname}/data/alinex.png)"

  describe "toText", ->

    it "should convert external image", ->
      @timeout 10000
      report = new Report()
      report.p Report.img "google", "http://google.de/favicon.ico"
      equal report.toText(), "[IMAGE google]"

    it "should convert external image with title", ->
      report = new Report()
      report.p Report.img "google", "http://google.de/favicon.ico", 'Google Logo'
      equal report.toText(), "[IMAGE google]"

    it "should convert local image", ->
      report = new Report()
      report.p Report.img "alinex", "file://#{path.dirname __dirname}/data/alinex.png"
      equal report.toText(), "[IMAGE alinex]"

  describe "toHTML", ->
    @timeout 5000

    it "should convert external image", ->
      report = new Report()
      report.p Report.img "google", "http://google.de/favicon.ico"
      body = report.toHtml().match(/<body>([\s\S]*?)<\/body>/)[1].trim()
      equal body, '<p><img src="http://google.de/favicon.ico" alt="google" /></p>'

    it "should convert external image with title", ->
      report = new Report()
      report.p Report.img "google", "http://google.de/favicon.ico", 'Google Logo'
      body = report.toHtml().match(/<body>([\s\S]*?)<\/body>/)[1].trim()
      equal body, '<p><img src="http://google.de/favicon.ico" alt="google"
      title="Google Logo" /></p>'

    it "should convert local image", ->
      report = new Report()
      report.p Report.img "alinex", "file://#{path.dirname __dirname}/data/alinex.png"
      fd = fs.createWriteStream "#{__dirname}/../../src/doc/inline-image.html"
      fd.write report.toHtml()
      fd.end()
      body = report.toHtml().match(/<body>([\s\S]*?)<\/body>/)[1].trim()
      expect(body.length).to.be.above 200
