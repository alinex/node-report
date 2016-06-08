# Plugin to add graphics
# ====================================================

# https://github.com/markdown-it/markdown-it/blob/master/docs/architecture.md
# https://github.com/markdown-it/markdown-it/blob/master/docs/development.md


# Node Modules
# -------------------------------------------

debug = require('debug') 'report:graph'


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
  token         = state.push 'fence', 'code', 0
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
    [type] = token.info.split /\s+/g
  switch type
    when 'progress'
      '<pre><b>PROGRESS</b></pre>\n'
    when 'mermaid'
      '<pre><b>MERMAID</b></pre>\n'
    when 'chart'
      '<pre><b>CHART</b></pre>\n'
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
