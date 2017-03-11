chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "style", ->

  describe "examples", ->
    @timeout 30000

    it "should make html block examples", (cb) ->
      test.markdown 'style/html-block', 'Test class\n\n<!-- {.red} -->', null, true, cb

    it "should make html inline examples", (cb) ->
      test.markdown 'style/html-inline', 'Test class<!-- {.red} -->', null, true, cb

  describe.skip "api", ->

    it "should create as block", (cb) ->
      # create report
      report = new Report()
      report.style '<div id="intro">foo</div>', 'html'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'raw', format: 'html', content: '<div id="intro">foo</div>'}
        {type: 'document', nesting: -1}
      ], null, cb
