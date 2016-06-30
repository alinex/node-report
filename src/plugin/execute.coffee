# Plugin to add graphics
# ====================================================

# https://github.com/markdown-it/markdown-it/blob/master/docs/architecture.md
# https://github.com/markdown-it/markdown-it/blob/master/docs/development.md


# Node Modules
# -------------------------------------------

debug = require('debug') 'report:execute'
deasync = require 'deasync'
path = require 'path'
{execFileSync} = require 'child_process'
QRCode = null # load on demand
#mermaid = null # load on demand
plantuml = null # load on demand
webshot = null # load on demand
# alinex modules
util = require 'alinex-util'
format = require 'alinex-format'
Table = require 'alinex-table'
fs = require 'alinex-fs'
# require 'mermaid' # used as binary


dataParse = deasync format.parse
dataStringify = deasync format.stringify


# Setup
# -------------------------------------------

MARKER = '$'.charCodeAt 0
CHARTNUM = 0


# Init plugin in markdown-it
# -------------------------------------------

module.exports = (md) ->
  debug "Init plugin..."
  # add parser rules
  md.block.ruler.before 'fence', 'execute', parser, ['paragraph', 'reference', 'blockquote', 'list']
  # add render rules
  md.renderer.rules.execute = renderer

module.exports.toConsole = module.exports.toText = (text) ->
  text.replace /\$\$\$\s+(css|js)\s*\n([\s\S]*?)\$\$\$/gi, ''
  # try to make unicode plantuml diagram
  .replace /\$\$\$\s+plantuml\s*\n([\s\S]*?)\$\$\$/gi, ->
    content = arguments[1]
    # create qr codes
    plantuml ?= require 'node-plantuml'
    renderer = deasync (code, cb) ->
      gen = plantuml.generate code.trim(),
        format: 'unicode'
      buffer = ''
      gen.out.on 'data', (data) -> buffer += data.toString()
      gen.out.on 'end', -> cb null, buffer
    renderer content
  # make text qr
  .replace /\$\$\$\s+qr\s*\n([\s\S]*?)\$\$\$/gi, ->
    content = arguments[1]
    # create qr codes
    QRCode ?= require 'qrcode-svg'
    data =
      padding: 4
      width: 256
      height: 256
      color: '#000000'
      background: '#ffffff'
      ecl: 'M'
    if content.match /(^|\n)\s*content:/
      util.extend data, dataParse content
    else
      data.content = content.trim()
    modules = new QRCode(data).qrcode.modules
    ascii = ''
    ascii += '██' for i in [0..modules.length+1]
    ascii += '\n'
    for y in [0..modules.length-1]
      ascii += '██'
      for x in [0..modules.length-1]
        ascii += if modules[x][y] then '  ' else '██'
      ascii += '██\n'
    ascii += '██' for i in [0..modules.length+1]
    ascii += '\n'
    ascii
  # show table instead of chart
  .replace /\$\$\$\s+chart\s*\n([\s\S]*?)\$\$\$/gi, ->
    part = arguments[1]
    parts = part.trim().split /(^|\n\s*\n\s*)\|/
    "|#{parts[2]}"
  # replace with code
  .replace /\$\$\$\s+(mermaid)\s*\n([\s\S]*?)\$\$\$/g, "``` $1\n$2```"
  # remove for all other
  .replace /\$\$\$([\s\S]*?)\$\$\$/g, '' # "```$1```"


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
  # add token
  token         = state.push 'execute', 'code', 0
  token.info    = params
  token.content = state.getLines startLine + 1, nextLine, len, true
  token.markup  = markup
  token.map     = [ startLine, state.line ]
  return true


# Renderer
# -------------------------------------------

renderer = (tokens, idx, options, env) ->
  token = tokens[idx]
  if token.info
    [type] = token.info.split /\s+/g
  switch type.toLowerCase()
    # coding
    when 'css'
      env.css ?= []
      env.css.push token.content.trim()
      ''

    when 'js'
      env.js ?= []
      env.js.push token.content.trim()
      """<script type="text/javascript"><!--\n#{token.content.trim()}\n//--></script>"""

    when 'qr'
      # create qr codes
      QRCode ?= require 'qrcode-svg'
      data =
        padding: 4
        width: 256
        height: 256
        color: '#000000'
        background: '#ffffff'
        ecl: 'M'
      if token.content.match /(^|\n)\s*content:/
        util.extend data, dataParse token.content, 'yaml'
      else
        data.content = token.content.trim()
      new QRCode(data).svg()

    when 'chart'
      [setup, _, table] = token.content.trim().split /(^|\n\s*\n\s*)\|/
      # parse table data
      td = []
      for line in util.string.toList "|#{table}"
        continue if line.match /^(\s|[|:-])+$/
        row = line.split /\s*\|\s*/
        td.push row[1..row.length - 2]
      # min max and step
      min = null
      max = null
      for row in td[1..]
        for cell in row[1..]
          continue unless util.number.isNumber cell
          v = parseFloat cell
          min ?= v
          min = v if v < min
          max ?= v
          max = v if v > max
      # chart definition
      data =
        width: 600
        height: 400
        axis:
          x:
            type: "block"
            domain: td[0][0]
            line: true
          y:
            type: "range"
            domain: [min, max]
            line: true
          data: Table.toRecordList td
        brush:
          type: "column"
          target: td[0][1..]
      util.extend 'MODE ARRAY_REPLACE', data, dataParse setup if setup
      # data.axis.data = table.data
      code = """
        jui.ready([ "chart.builder" ], function(chart) {
          chart("#chart#{++CHARTNUM}", #{dataStringify data, 'js'});
        })
        """
      html = """<div id="chart#{CHARTNUM}"></div>
        <script type="text/javascript"><!--\n#{code}\n//--></script>"""
      # normal javascript display
      unless env.noJS
        env.js ?= []
        env.js.push code
        return html
      # add html geader
      html = require('../html').frame html, null, code
      # convert to javascript
      webshot ?= require 'webshot'
      convert = deasync (html, cb) ->
        options =
          siteType: 'html'
          streamType: 'png'
          creenSize:
            width: 800
            height: 600
          captureSelector: '#page svg'
          renderDelay: 100
        webshot html, options, (err, stream) ->
          buffer = ''
          return cb err if err
          stream.on 'data', (data) -> buffer += data.toString 'binary'
          stream.on 'end', ->
            cb null, buffer
      data = convert html
      image = new Buffer(data, 'binary').toString 'base64'
      """<p><img src="data:application/octet-stream;base64,#{image}"></p>"""

    when 'plantuml'
      plantuml ?= require 'node-plantuml'
      renderer = deasync (code, cb) ->
        gen = plantuml.generate code.trim(),
          format: 'svg'
        buffer = ''
        gen.out.on 'data', (data) -> buffer += data.toString()
        gen.out.on 'end', -> cb null, buffer
      renderer token.content

    when 'mermaid'
      # setup command processing
      mermaid = fs.npmbinSync 'mermaid', __dirname
      phantomjs = fs.npmbinSync 'phantomjs', __dirname
      tempdir = fs.tempdirSync()
      fs.writeFileSync "#{tempdir}/mermaid", token.content
      # create image
      execFileSync mermaid, [
        '-e', phantomjs
        '-t', "#{path.dirname mermaid}/../mermaid/dist/mermaid.forest.css"
        '-o', "#{tempdir}"
#        '-s'
        "#{tempdir}/mermaid"
      ]
      # load image into img tag
#      fs.readFileSync("#{tempdir}/mermaid.svg").toString 'utf-8'
      image = fs.readFileSync("#{tempdir}/mermaid.png").toString 'base64'
      fs.remove tempdir
      style = if token.content.trim().match /^gantt/i then '' else "style=\"max-width: 100%\""
      """<p><img #{style} src="data:application/octet-stream;base64,#{image}"></p>"""

#    when 'mermaid-api'
#      code = """
#        // mermaid.initialize
#        $(function(){
#          var cb = function(svg){
#            document.querySelector("#mermaid#{++MERMAIDNUM}").innerHTML = svg;
#          };
#          mermaidAPI.render('mermaid#{MERMAIDNUM}',\
#            '#{token.content.replace /\n/g, '\\n'}', cb);
#        });
#        """
#      html = """<div id="mermaid#{MERMAIDNUM}"></div>
#        <script type="text/javascript"><!--\n#{code}\n//--></script>"""
#      # normal javascript display
#      unless env.noJS
#        env.js ?= []
#        env.js.push code
#        return html
#      # add html geader
#      html = require('../html').frame html, null, code
#      html = html.replace /display:\s*inline-block/, ''
#      # convert to javascript
#      webshot ?= require 'webshot'
#      convert = deasync (html, cb) ->
#        options =
#          siteType: 'html'
#          streamType: 'png'
#          creenSize:
#            width: 800
#            height: 600
##          captureSelector: '#page'
#          captureSelector: '#page svg'
#          renderDelay: 100
#        webshot html, options, (err, stream) ->
#          return cb err if err
#          buffer = ''
#          stream.on 'data', (data) -> buffer += data.toString 'binary'
#          stream.on 'end', -> cb null, buffer
#      data = convert html
#      image = new Buffer(data, 'binary').toString 'base64'
#      """<p><img src="data:application/octet-stream;base64,#{image}"></p>"""

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
