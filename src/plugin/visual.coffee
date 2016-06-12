# Plugin to add graphics
# ====================================================

# https://github.com/markdown-it/markdown-it/blob/master/docs/architecture.md
# https://github.com/markdown-it/markdown-it/blob/master/docs/development.md


# Node Modules
# -------------------------------------------

debug = require('debug') 'report:graph'
deasync = require 'deasync'
QRCode = null # load on demand
jui = null # load on demand
mermaid = null # load on demand
# alinex modules
util = require 'alinex-util'
format = require 'alinex-format'
Table = require 'alinex-table'

dataParser = deasync format.parse


# Setup
# -------------------------------------------

MARKER = '$'.charCodeAt 0


# Init plugin in markdown-it
# -------------------------------------------

module.exports = (md) ->
  debug "Init graph plugin..."
  # add parser rules
  md.block.ruler.before 'fence', 'graph', parser, ['paragraph', 'reference', 'blockquote', 'list']
  # add render rules
  md.renderer.rules.graph = renderer

module.exports.toText = (text) ->
  text.replace /\$\$\$\s+qr\s*\n([\s\S]*?)\$\$\$/g, ->
    part = arguments[1]
    if part.match /(^|\n)\s*content:/
      data = dataParser part
      "==QR Code: #{data.content}=="
    else
      "==QR Code: #{part.trim()}=="
  text.replace /\$\$\$\s+chart\s*\n([\s\S]*?)\$\$\$/g, ->
    part = arguments[1]
    parts = part.trim().split /(^|\n\s*\n\s*)\|/
    "|#{parts[2]}"
  .replace /\$\$\$([\s\S]*?)\$\$\$/g, "```$1```"


# Parser
# -------------------------------------------

parser = (state, startLine, endLine, silent) ->
  haveEndMarker = false
  pos = state.bMarks[startLine] + state.tShift[startLine]
  max = state.eMarks[startLine]
  return false if pos + 3 > max
  return false unless MARKER is state.src.charCodeAt pos
  # scan marker length
  mem = pos
  pos = state.skipChars pos, MARKER
  len = pos - mem
  return false if len < 3
  markup = state.src.slice mem, pos
  params = state.src.slice(pos, max).trim()
  # Since start is found, we can report success here in validation mode
  return false if silent
  # search end of block
  nextLine = startLine
  loop
    nextLine++
    # unclosed block should be autoclosed by end of document.
    # also block seems to be autoclosed by end of parent
    break if nextLine >= endLine
    pos = mem = state.bMarks[nextLine] + state.tShift[nextLine]
    max = state.eMarks[nextLine]
    # non-empty line with negative indent should stop the list:
    # - $$$
    #  test
    break if pos < max and state.sCount[nextLine] < state.blkIndent
    continue unless state.src.charCodeAt(pos) is MARKER
    # closing fence should be indented less than 4 spaces
    continue if state.sCount[nextLine] - state.blkIndent >= 4
    pos = state.skipChars(pos, MARKER)
    # closing code fence must be at least as long as the opening one
    continue if pos - mem < len
    # make sure tail has spaces only
    pos = state.skipSpaces pos
    continue if pos < max
    haveEndMarker = true
    # found!
    break
  # If a fence has heading spaces, they should be removed from its inner block
  len = state.sCount[startLine]
  state.line = nextLine + if haveEndMarker then 1 else 0
  token         = state.push 'graph', 'code', 0
  token.info    = params
  token.content = state.getLines startLine + 1, nextLine, len, true
  token.markup  = markup
  token.map     = [ startLine, state.line ]
  return true


# Renderer
# -------------------------------------------

renderer = (tokens, idx, options, env, self) ->
  token = tokens[idx]
  if token.info
    [type, opt] = token.info.split /\s+/g
  switch type

    # create qr codes
    when 'qr'
      QRCode ?= require 'qrcode-svg'
      data =
        padding: 4
        width: 256
        height: 256
        color: '#000000'
        background: '#ffffff'
        ecl: 'M'
      if token.content.match /(^|\n)\s*content:/
        util.extend data, dataParser token.content
        data.content = token.content.trim()
      else
      new QRCode(data).svg()

    # create qr codes
    when 'chart'
      [setup, _, table] = token.content.trim().split /(^|\n\s*\n\s*)\|/
      jui = require 'jui'
      data = util.extend
        width: 800
        height: 800
        axis:
          x:
            type: "block"
            domain: "quarter"
            line: true
          y:
            type: "range"
            domain: (d) -> Math.max d.sales, d.profit
            step: 20,
            line: true,
            orient: "right"
        brush:
          type: "column"
          target: ["sales", "profit"]
      , dataParser setup
      # parse table data
      td = []
      for line in util.string.toList "|#{table}"
        continue if line.match /^(\s|[|:-])+$/
        row = line.split /\s*\|\s*/
        td.push row[1..row.length - 2]
      data.axis.data = Table.toRecordList td
      # data.axis.data = table.data
      jui.create('chart.builder', null, data).svg.toXML()


    # mermaid graph
    # TODO won't work without xmkdom
    when 'graph'
      mermaid ?= require 'mermaid'
      renderer = deasync (code, cb) ->
        mermaid.mermaidAPI.render 'mermaid', code, (svg) ->
          cb null, svg
      renderer "#{type} #{opt.join ' '}\n#{token.content}"
    else
      escapeHtml token.content


# Helper
# -------------------------------------------
escapeHtmlChars =
  '&': '&amp;'
  '<': '&lt;'
  '>': '&gt;'
  '"': '&quot;'

escapeHtml = (str) ->
  str.replace /[&<>"]/g, (e) -> escapeHtmlChars[e]
