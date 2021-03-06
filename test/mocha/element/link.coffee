chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "link", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'link/simple', "Let's [google](http://www.google.com \"search engine\")
      for everything you don't know.", null, true, cb

  describe "api", ->

    it "should create link in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.link 'foo', '/url', 'title'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create link in multiple steps", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.link true, '/url', 'title'
      report.text 'foo'
      report.link false
      report.paragraph false
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create link in paragraph (shorthand call)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.a 'foo', '/url', 'title'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url', title: 'title'}
        {type: 'text', content: 'foo'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create link in paragraph (with only url)", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.link '/url'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'link', nesting: 1, href: '/url'}
        {type: 'text', content: '/url'}
        {type: 'link', nesting: -1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should fail link if not in inline element", (cb) ->
      # create report
      report = new Report()
      expect(-> report.a '/url').to.throw Error
      cb()

    it "should fail without content", (cb) ->
      # create report
      report = new Report()
      expect(-> report.a true).to.throw Error
      cb()

    it "should not use fuzzy link because to insecure", (cb) ->
      test.markdown 'link/simple', "See the {@link Changelog.md} for a list of
      changes in recent versions.", [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'text', content: 'See the {@link Changelog.md} for a list of changes in recent versions.'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
