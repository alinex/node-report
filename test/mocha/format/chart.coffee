### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'

describe.only "visual chart", ->
  @timeout 10000

  it "should create simple chart", (cb) ->
    report = new Report()
    report.chart null, [
      ['quarter', 'sales', 'profit']
      ["1Q", 50, 35]
      ["2Q", -20, -100]
      ["3Q", 10, -5]
      ["4Q", 30, 25]
    ]
    test.report 'chart', report, """

      $$$ chart
      | quarter | sales | profit |
      |:------- |:----- |:------ |
      | 1Q      | 50    | 35     |
      | 2Q      | -20   | -100   |
      | 3Q      | 10    | -5     |
      | 4Q      | 30    | 25     |
      $$$

      """, null, cb

  it "should create", (cb) ->
    report = new Report()
    test.report 'chart', report, null, null, cb
