### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'
Table = require 'alinex-table'

data =
  salesyear: new Table [
    ['quarter', 'sales', 'profit']
    ["2015/Q1", 50, 35]
    ["2015/Q2", 20, 100]
    ["2015/Q3", 10, 5]
    ["2015/Q4", 30, 25]
  ]
  salesregion: new Table [
    ['year', 'europe', 'switzerland', 'us']
    ['2008', 10, 1, 0]
    ['2009', 60, 3, 0]
    ['2010', 30, 3, 12]
    ['2011', -60, 4, 15]
    ['2012', 50, 6, 20]
    ['2013', 30, 5, 35]
    ['2014', 20, 8, 20]
    ['2015', 100, 0, 0]
  ]

describe "visual chart", ->
  @timeout 20000

  it "should create simple chart", (cb) ->
    report = new Report()
    report.chart null, data.salesyear
    test.report 'chart', report, null, null, cb

  it "should create area chart", (cb) ->
    report = new Report()
    report.chart
      width: 400
      height: 400
      axis:
        x:
          type: 'fullblock'
          domain: 'year'
          line: 'solid gradient'
        y:
          type: 'range'
          domain: [-100, 100]
          step: 10
          line: 'gradient dashed'
      brush: [
        type: 'area'
        symbol: 'curve'
        target: ['europe', 'switzerland', 'us']
      ]
      widget: [
        type: 'title'
        text: 'Area Chart'
      ,
      	type: 'legend'
      ]
    , data.salesyear
    test.report 'chart-area', report, null, null, cb

  it "should create bar chart", (cb) ->
    report = new Report()
    report.chart
      width: 400
      height: 400
      axis:
        y:
          type: 'block'
          domain: 'quarter'
          line: 'true'
        x:
          type: 'range'
          domain: 'profit'
          line: 'rect' # dashed with gradient
      brush: [
        type: 'bar'
        size: 15
        target: ['sales', 'profit']
        innerPadding: 10
      ]
      widget: [
        type: 'title'
        text: 'Bar Chart'
      ,
      	type: 'legend'
      ,
      	type: 'tooltip'
      ]
    , data.salesyear
    test.report 'chart-bar', report, """

      $$$ chart
      width: 400
      height: 400
      axis:
        'y':
          type: block
          domain: quarter
          line: 'true'
        x:
          type: range
          domain: profit
          line: rect
      brush:
        - type: bar
          size: 15
          target:
            - sales
            - profit
          innerPadding: 10
      widget:
        - type: title
          text: Bar Chart
        - type: legend
        - type: tooltip

      | quarter | sales | profit |
      |:------- |:----- |:------ |
      | 2015/Q1 | 50    | 35     |
      | 2015/Q2 | 20    | 100    |
      | 2015/Q3 | 10    | 5      |
      | 2015/Q4 | 30    | 25     |
      $$$

      """, null, cb

  it "should create 3D bar chart", (cb) ->
    report = new Report()
    report.chart
      width: 400
      height: 400
      axis:
        x:
          type: 'range'
          domain: 'profit'
          step: 5
        y:
          type: 'block'
          domain: 'quarter'
        c:
          type: 'grid3d'
          domain: ['sales', 'profit']
        depth: 20
        degree: 30
      brush: [
        type: 'bar3d'
        outerPadding: 10
        innerPadding: 5
      ]
      widget: [
        type: 'title'
        text: '3D Bar Chart'
      ,
      	type: 'tooltip'
      ,
      	type: 'legend'
      ]
    , data.salesyear
    test.report 'chart-bar-3d', report, null, null, cb

  it "should create column chart", (cb) ->
    report = new Report()
    report.chart
      width: 400
      height: 400
      axis:
        x:
          type: 'block'
          domain: 'quarter'
        y:
          type: 'range'
          domain: 'profit'
          step: 10
          line: true
      brush: [
        type: 'column'
        target: ['sales', 'profit']
      ,
        type: 'focus'
        start: 1
        end: 1
      ]
      widget: [
        type: 'title'
        text: 'Column Chart with Focus'
      ,
      	type: 'tooltip'
      ,
      	type: 'legend'
      ]
    , data.salesyear
    test.report 'chart-column', report, null, null, cb

  it "should create 3D column chart", (cb) ->
    report = new Report()
    report.chart
      width: 400
      height: 400
      axis:
        x:
          type: 'block'
          domain: 'quarter'
        y:
          type: 'range'
          domain: 'profit'
          step: 5
        c:
          type: 'grid3d'
          domain: ['sales', 'profit']
        depth: 20
        degree: 30
      brush: [
        type: 'column3d'
        outerPadding: 10
        innerPadding: 5
      ]
      widget: [
        type: 'title'
        text: '3D Column Chart'
      ,
      	type: 'tooltip'
      ,
      	type: 'legend'
      ]
    , data.salesyear
    test.report 'chart-column-3d', report, null, null, cb

  it.skip "should create", (cb) ->
    report = new Report()
    test.report 'chart', report, null, null, cb

  it.skip "should create", (cb) ->
    report = new Report()
    test.report 'chart', report, null, null, cb
