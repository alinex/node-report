chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "raw", ->

  describe "examples", ->
    @timeout 30000

    it "should make html block examples", (cb) ->
      test.markdown 'raw/html-block', '<div style="background:orange">\n\nAn html <a class="red">block</a>.', null, true, cb

    it "should make html inline examples", (cb) ->
      test.markdown 'raw/html-inline', 'Some <a class="red">inline</a> html.', null, true, cb

  describe "api", ->

    it "should create as block", (cb) ->
      # create report
      report = new Report()
      report.raw '<div id="intro">foo</div>', 'html'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'raw', format: 'html', content: '<div id="intro">foo</div>'}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should autodetect html format", (cb) ->
      # create report
      report = new Report()
      report.raw '<div id="intro">foo</div>'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'raw', format: 'html', content: '<div id="intro">foo</div>'}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should create in paragraph", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.raw '<div id="intro">foo</div>', 'html'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'raw', format: 'html', content: '<div id="intro">foo</div>'}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should do nothing without content", (cb) ->
      # create report
      report = new Report()
      report.paragraph true
      report.raw()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'paragraph', nesting: 1}
        {type: 'paragraph', nesting: -1}
        {type: 'document', nesting: -1}
      ], null, cb
