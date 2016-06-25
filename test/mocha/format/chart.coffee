### eslint-env node, mocha ###
Report = require '../../../src/index'
test = require '../test'
Table = require 'alinex-table'

describe "visual chart", ->
  @timeout 10000

  it.only "should create simple chart", (cb) ->
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

  it "should create column chart", (cb) ->
    report = new Report()
    report.chart
      width: 800
      height: 400
      theme: 'dark'
      axis:
        padding:
          left: 5
          top: 10
        area:
          width: '80%'
          x: '10%'
        x:
          type: 'block'
          domain: "quarter"
          line: true
        y:
          type: 'range'
          domain: [-120, 120]
          step: 10
          line: true
          orient: 'right'
      brush: [
        type: "column"
        target: ["sales", "profit"]
      ,
        type: "focus"
        start: 1
        end: 1
      ]
      widget: [
        type: "title"
        text: "Column Chart"
      ,
        type: "tooltip"
      ,
        type: "legend"
      ]
    , [
      ['quarter', 'sales', 'profit']
      ["1Q", 50, 35]
      ["2Q", -20, -100]
      ["3Q", 10, -5]
      ["4Q", 30, 25]
    ]
    test.report 'chart-column', report, """

      $$$ chart
      width: 800
      height: 400
      theme: dark
      axis:
        padding:
          left: 5
          top: 10
        area:
          width: 80%
          x: 10%
        x:
          type: block
          domain: quarter
          line: true
        'y':
          type: range
          domain:
            - -120
            - 120
          step: 10
          line: true
          orient: right
      brush:
        - type: column
          target:
            - sales
            - profit
        - type: focus
          start: 1
          end: 1
      widget:
        - type: title
          text: Column Chart
        - type: tooltip
        - type: legend

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
    report.chart
      axis:
        x:
          type: 'block'
          domain: 'date'
          line: true
        y:
          type: 'range'
          domain: [
            20
            30
          ]
          step: 5
          line: true
        keymap:
          low: 'l'
          high: 'h'
          open: 'o'
          close: 'c'
      brush: type: 'candlestick'
      widget:
        type: 'tooltip'
        orient: 'bottom'
    , Table.fromRecordList [
      {
        date: new Date(1994, 2, 1)
        l: 24.00
        h: 25.00
        o: 25.00
        c: 24.875
      }
      {
        date: new Date(1994, 2, 2)
        l: 23.625
        h: 25.125
        o: 24.00
        c: 24.875
      }
      {
        date: new Date(1994, 2, 3)
        l: 26.25
        h: 28.25
        o: 26.75
        c: 27.00
      }
      {
        date: new Date(1994, 2, 4)
        l: 26.50
        h: 27.875
        o: 26.875
        c: 27.25
      }
      {
        date: new Date(1994, 2, 7)
        l: 26.375
        h: 27.50
        o: 27.375
        c: 26.75
      }
      {
        date: new Date(1994, 2, 8)
        l: 25.75
        h: 26.875
        o: 26.75
        c: 26.00
      }
      {
        date: new Date(1994, 2, 9)
        l: 25.75
        h: 26.75
        o: 26.125
        c: 26.25
      }
      {
        date: new Date(1994, 2, 10)
        l: 25.75
        h: 26.375
        o: 26.375
        c: 25.875
      }
      {
        date: new Date(1994, 2, 11)
        l: 24.875
        h: 26.125
        o: 26.00
        c: 25.375
      }
      {
        date: new Date(1994, 2, 14)
        l: 25.125
        h: 26.00
        o: 25.625
        c: 25.75
      }
      {
        date: new Date(1994, 2, 15)
        l: 25.875
        h: 26.625
        o: 26.125
        c: 26.375
      }
      {
        date: new Date(1994, 2, 16)
        l: 26.25
        h: 27.375
        o: 26.25
        c: 27.25
      }
      {
        date: new Date(1994, 2, 17)
        l: 26.875
        h: 27.25
        o: 27.125
        c: 26.875
      }
      {
        date: new Date(1994, 2, 18)
        l: 26.375
        h: 27.125
        o: 27.00
        c: 27.125
      }
      {
        date: new Date(1994, 2, 21)
        l: 26.75
        h: 27.875
        o: 26.875
        c: 27.75
      }
      {
        date: new Date(1994, 2, 22)
        l: 26.75
        h: 28.375
        o: 27.50
        c: 27.00
      }
      {
        date: new Date(1994, 2, 23)
        l: 26.875
        h: 28.125
        o: 27.00
        c: 28.00
      }
      {
        date: new Date(1994, 2, 24)
        l: 26.25
        h: 27.875
        o: 27.75
        c: 27.625
      }
      {
        date: new Date(1994, 2, 25)
        l: 27.50
        h: 28.75
        o: 27.75
        c: 28.00
      }
      {
        date: new Date(1994, 2, 28)
        l: 25.75
        h: 28.25
        o: 28.00
        c: 27.25
      }
      {
        date: new Date(1994, 2, 29)
        l: 26.375
        h: 27.50
        o: 27.50
        c: 26.875
      }
      {
        date: new Date(1994, 2, 30)
        l: 25.75
        h: 27.50
        o: 26.375
        c: 26.25
      }
      {
        date: new Date(1994, 2, 31)
        l: 24.75
        h: 27.00
        o: 26.50
        c: 25.25
      }
    ]
    test.report 'chart-candlestick', report, null, null, cb

# ---
# generated by js2coffee 2.2.0

  it.skip "should create", (cb) ->
    report = new Report()
    test.report 'chart', report, null, null, cb

  it.skip "should create", (cb) ->
    report = new Report()
    test.report 'chart', report, null, null, cb

  it.skip "should create", (cb) ->
    report = new Report()
    test.report 'chart', report, null, null, cb

  it.skip "should create", (cb) ->
    report = new Report()
    test.report 'chart', report, null, null, cb

  it.skip "should create", (cb) ->
    report = new Report()
    test.report 'chart', report, null, null, cb
