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

describe "visual qr", ->

  it "should make simple qr markup", ->
    result = Report.qr 'http://alinex.github.io'
    expect(result).to.equal """
    \n$$$ qr
    http://alinex.github.io
    $$$\n
    """

  it "should make simple qr graphic", ->
    text = """
    $$$ qr
      http://alinex.github.io
    $$$
    """
    result = test 'qr-simple', text
    expect(result).to.contain '<svg'
    expect(plugin.toText text).to.equal '==QR Code: http://alinex.github.io=='

  it "should make extended qr markup", ->
    result = Report.qr
      content: 'http://alinex.github.io'
      padding: 1
      width: 600
      height: 600
      color: '#ff0000'
      background: '#ffffff'
      ecl: 'M'
    expect(result).to.equal """
    \n$$$ qr
    content: 'http://alinex.github.io'
    padding: 1
    width: 600
    height: 600
    color: '#ff0000'
    background: '#ffffff'
    ecl: M
    $$$\n
    """

  it "should make extended qr graphic", ->
    text = """
    $$$ qr
      content: http://alinex.github.io
      padding: 1
      width: 600
      height: 600
      color: #ff0000
      background: #ffffff
      ecl: M
    $$$
    """
    result = test 'qr-extended', text
    expect(result).to.contain '<svg'
    expect(plugin.toText text).to.equal '==QR Code: http://alinex.github.io=='
