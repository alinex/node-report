chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

markdownit = require 'markdown-it'
plugin = require '../../../src/plugin/visual'
fs = require 'alinex-fs'

test = (name, text) ->
  md = markdownit().use plugin
  result = md.render text
  fd = fs.createWriteStream "#{__dirname}/../../../src/doc/visual-#{name}.html"
  fd.write result
  fd.end()
  result

describe "visual chart", ->

  it "should make bar chart graphic", ->
    text = """
    $$$ chart
    width: 400
    height: 400
    theme: 'jennifer'
    axis:
      y:
        type: 'fullblock'
        domain: ['week1', 'week2', 'week3', 'week4']
        line: true
      x:
        type: 'range'
        domain: [-15, 20]
        line: rect
    brush:
      - type: 'bar'
        size: 15
        target: ['name', 'value', 'test']
        innerPadding: 10
        display: all
    widget:
      - type: 'title'
        text: 'Bar Chart'
      - type: 'legend'
    style:
      tooltipPointFontWeight: "normal"
      tooltipPointRadius: 5
      tooltipPointBorderWidth: 1.5
      titleFontWeight: "bold"

    | name | value | test | test2 |
    |------|-------|------|-------|
    | 2    | 15    | -7   | -7    |
    | 15   | 6     | -2   | -7    |
    | 8    | 10    | -5   | -7    |
    | 18   | 5     | -12  | -7    |
    $$$
    """
    result = test 'chart-bar', text
    expect(result).to.contain '<svg'

  it "should make 3d bar chart graphic", ->
    text = """
    $$$ chart
    width: 800
    height: 400
    theme: jennifer
    axis:
      padding:
        left: 5
        top: 10
      area:
        width: 80%
        x: 10%
      x:
        type: range
        domain: [-100, 100]
        step: 5
      y:
        type: block
        domain: quarter
      c:
        type: grid3d
        domain: [sales, profit]
      depth: 20
      degree: 30
    brush:
      - type: bar3d
        outerPadding: 10
        innerPadding: 5
    widget:
      - type: title
        text: "Column Chart"
    style:
      gridAxisBorderColor: "black"
      gridBorderColor: "#dcdcdc"

    | quarter | sales | profit |
    | ------- | ----- | ------ |
    | 1Q      | 50    | 35     |
    | 2Q      | -20   | -100   |
    | 3Q      | 10    | -5     |
    | 4Q      | 30    | 25     |
    $$$
    """
    result = test 'chart-bar3d', text
    expect(result).to.contain '<svg'
