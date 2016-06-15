chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

Report = require '../../../src/index'
markdownit = require 'markdown-it'
plugin = require '../../../src/plugin/code'
fs = require 'alinex-fs'

test = (name, text) ->
  md = markdownit().use plugin
  result = md.render text
  fd = fs.createWriteStream "#{__dirname}/../../../src/doc/code-#{name}.html"
  fd.write result
  fd.end()
  result

describe "code chart", ->

  it "should make animate chart graphic", ->
    text = """
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
        type: range
        domain: sales
        step: 10
        line: true
        orient: right
      y:
        type: block
        domain: quarter
        line: true
   brush:
      - type: "bar"
        target: "sales"
        display: "max"
        active: 5
        activeEvent: "click"
        animate: "right"
      - type: "focus"
        start: 1
        end: 1
    widget:
      - type: title
        text: "Bar Chart"
        align: start
      - type: legend

    | quarter | sales | profit |
    | ------- | ----- | ------ |
    | 1Q      | 50    | 35     |
    | 2Q      | -20   | -100   |
    | 3Q      | 10    | -5     |
    | 4Q      | 30    | 25     |
    $$$
    """
    result = test 'chart-animate', text
    expect(result).to.contain '<svg'
