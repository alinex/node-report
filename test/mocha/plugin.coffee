chai = require 'chai'
expect = chai.expect
### eslint-env node, mocha ###

markdownit = require 'markdown-it'
plugin = require '../../src/plugin'

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
      console.log tokens
      result = md.renderer.render tokens, md.options, env
      expect(result).to.equal('<h1>Heading</h1>\n')
