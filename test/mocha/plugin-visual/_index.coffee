chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

Report = require '../../../src/index'
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

describe "visual", ->

  describe "base", ->

    it "should work without plugin", ->
      result = test 'default', "# Heading"
      expect(result).to.equal('<h1>Heading</h1>\n')

    it "should work using extra renderer call", ->
      md = markdownit().use plugin
      env = {}
      tokens = md.parse "# Heading", env
      result = md.renderer.render tokens, md.options, env
      expect(result).to.equal('<h1>Heading</h1>\n')

  describe "chart", ->

    it "should make simple chart markup", ->
      result = Report.chart null, [
        ['quarter', 'sales', 'profit']
        ["1Q", 50, 35]
        ["2Q", -20, -100]
        ["3Q", 10, -5]
        ["4Q", 30, 25]
      ]
      expect(result).to.equal """
      \n$$$ chart
      | quarter | sales | profit |
      |:------- |:----- |:------ |
      | 1Q      | 50    | 35     |
      | 2Q      | -20   | -100   |
      | 3Q      | 10    | -5     |
      | 4Q      | 30    | 25     |
      $$$\n
      """

    it "should make simple chart graphic", ->
      text = """
      $$$ chart
      | quarter | sales | profit |
      | ------- | ----- | ------ |
      | 1Q      | 50    | 35     |
      | 2Q      | -20   | -100   |
      | 3Q      | 10    | -5     |
      | 4Q      | 30    | 25     |
      $$$
      """
      result = test 'chart-simple', text
      expect(result).to.contain '<svg'
      expect(plugin.toText text).to.equal """
      | quarter | sales | profit |
      | ------- | ----- | ------ |
      | 1Q      | 50    | 35     |
      | 2Q      | -20   | -100   |
      | 3Q      | 10    | -5     |
      | 4Q      | 30    | 25     |
      """

# https://github.com/juijs/jui-chart/tree/develop/sample
# http://chartplay.jui.io/

  describe.skip "graph", ->

    it "should make simple graph code", ->
      result = test 'graph-td', """
      $$$ graph TD
        A -> B
      $$$
      """
      expect(result).to.contain '<svg'
