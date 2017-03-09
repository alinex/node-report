chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "image", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'image/simple', "An ![alinex](http://alinex.github.io/images/Alinex-200.png \"my logo\") project.", null, true, cb

  describe "api", ->

    it "should create image in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.image 'foo', '/url', 'title'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'image', nesting: 1, src: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'image', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create image in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.image true, '/url', 'title'
      report.text 'foo'
      report.image false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'image', nesting: 1, src: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'image', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create image in paragraph (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.img 'foo', '/url', 'title'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'image', nesting: 1, src: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'image', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create image in paragraph (with only source)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.image '/url'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'image', nesting: 1, src: '/url'}
        {type: 'text', content: '/url'}
        {type: 'image', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail image if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.img '/url').to.throw Error
      cb()

    it "should fail without content", (cb) ->
      # create report
      report = new Report()
      expect(-> report.a true).to.throw Error
      cb()
