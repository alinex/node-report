chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

markdownit = require 'markdown-it'
plugin = require '../../src/plugin'
fs = require 'alinex-fs'

describe "graph", ->

  describe.only "base", ->

    it "should work without plugin", ->
      md = markdownit().use plugin
      result = md.render "# Heading"
      expect(result).to.equal('<h1>Heading</h1>\n')

    it "should work using extra renderer call", ->
      md = markdownit().use plugin
      env = {}
      tokens = md.parse "# Heading", env
      result = md.renderer.render tokens, md.options, env
      expect(result).to.equal('<h1>Heading</h1>\n')

  describe.only "qr", ->

    it "should make simple qr code", ->
      md = markdownit().use plugin
      env = {}
      tokens = md.parse """
      $$$ qr
      http://alinex.github.io
      $$$
      """, env
      result = md.renderer.render tokens, md.options, env
      fd = fs.createWriteStream "#{__dirname}/../data/qr-simple.html"
      fd.write result
      fd.end()
      expect(result).to.contain '<svg'

    it "should make extended qr code", ->
      md = markdownit().use plugin
      env = {}
      tokens = md.parse """
      $$$ qr
      content: http://alinex.github.io
      padding: 1
      width: 600
      height: 600
      color: #ff0000
      background: #ffffff
      ecl: M
      $$$
      """, env
      result = md.renderer.render tokens, md.options, env
      fd = fs.createWriteStream "#{__dirname}/../data/qr-extended.html"
      fd.write result
      fd.end()
      expect(result).to.contain '<svg'

  describe.only "graph", ->

    it "should make simple graph code", ->
      md = markdownit().use plugin
      env = {}
      tokens = md.parse """
      $$$ graph TD
        A -> B
      $$$
      """, env
      result = md.renderer.render tokens, md.options, env
      fd = fs.createWriteStream "#{__dirname}/../data/graph-td.html"
      fd.write result
      fd.end()
      expect(result).to.contain '<svg'
