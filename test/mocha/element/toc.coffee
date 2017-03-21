### eslint-env node, mocha ###
test = require '../test'
async = require 'async'

Report = require '../../../src'
before (cb) -> Report.init cb

describe "toc", ->

  describe "examples", ->
    @timeout 30000

    it "should make examples", (cb) ->
      test.markdown 'toc/simple', """
      @[toc]

      # heading 1

      ## heading 2

      ### heading 3

      ## heading 2
      """, null, true, cb

  describe "api", ->

    it "should add element", (cb) ->
      # create report
      report = new Report()
      report.toc()
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'toc', nesting: 0}
        {type: 'document', nesting: -1}
      ], null, cb

    it "should add element with title", (cb) ->
      # create report
      report = new Report()
      report.toc 'Index'
      # check it
      test.report null, report, [
        {type: 'document', nesting: 1}
        {type: 'toc', nesting: 0, title: 'Index'}
        {type: 'document', nesting: -1}
      ], null, cb
