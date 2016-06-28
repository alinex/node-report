### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe.only "visual mermaid", ->
  @timeout 20000

  it "should create simple chart", (cb) ->
    report = new Report()
    report.mermaid """
      graph LR
        A-->B
      """
    test.report 'mermaid', report, null, null, cb
