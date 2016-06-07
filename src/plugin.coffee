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
  # register all graph dialects
  for name in ['mermaid']
    # add parser rules
    md.block.ruler.before 'fence', 'graph_' + name, parser.mermaid
    # add render rules
    md.renderer.rules['graph_' + name + '_open'] = renderer.mermaid
    md.renderer.rules['graph_' + name + '_close'] = renderer.mermaid


# Parser
# -------------------------------------------

parser =
  mermaid: (state, startLine, endLine, silent) ->
    haveEndMarker = false
    pos = state.bMarks[startLine] + state.tShift[startLine]
    max = state.eMarks[startLine]
    return false if pos + 3 > max
    return false unless MARKER id state.src.charCodeAt pos
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
    nextLine = startLine;
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
      break;
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

renderer =
  mermaid: (tokens, idx, options, env, self) ->
    return "htmlResult"

return





module.exports = (md, name, options) ->

  options = options or {}
  min_markers = 3
  marker_str = options.marker or ':'
  marker_char = marker_str.charCodeAt(0)
  marker_len = marker_str.length
  validate = options.validate or validateDefault
  render = options.render or renderDefault
  md.block.ruler.before 'fence', 'container_' + name, container,
    alt: [
      'paragraph'
      'reference'
      'blockquote'
      'list'
    ]
  md.renderer.rules['container_' + name + '_open'] = render
  md.renderer.rules['container_' + name + '_close'] = render
  return

  validateDefault = (params) ->
    params.trim().split(' ', 2)[0] is name

  renderDefault = (tokens, idx, _options, env, self) ->
    # add a class to the opening tag
    if tokens[idx].nesting is 1
      tokens[idx].attrPush [
        'class'
        name
      ]
    self.renderToken tokens, idx, _options, env, self

  container = (state, startLine, endLine, silent) ->
    pos = undefined
    nextLine = undefined
    marker_count = undefined
    markup = undefined
    params = undefined
    token = undefined
    old_parent = undefined
    old_line_max = undefined
    auto_closed = false
    start = state.bMarks[startLine] + state.tShift[startLine]
    max = state.eMarks[startLine]
    # Check out the first character quickly,
    # this should filter out most of non-containers
    #
    unless marker_char is state.src.charCodeAt(start)
      return false
    # Check out the rest of the marker string
    #
    pos = start + 1
    while pos <= max
      if marker_str[(pos - start) % marker_len] isnt state.src[pos]
        break
      pos++
    marker_count = Math.floor((pos - start) / marker_len)
    if marker_count < min_markers
      return false
    pos -= (pos - start) % marker_len
    markup = state.src.slice(start, pos)
    params = state.src.slice(pos, max)
    if not validate(params)
      return false
    # Since start is found, we can report success here in validation mode
    #
    if silent
      return true
    # Search for the end of the block
    #
    nextLine = startLine
    loop
      nextLine++
      if nextLine >= endLine
        # unclosed block should be autoclosed by end of document.
        # also block seems to be autoclosed by end of parent
        break
      start = state.bMarks[nextLine] + state.tShift[nextLine]
      max = state.eMarks[nextLine]
      if start < max and state.sCount[nextLine] < state.blkIndent
        # non-empty line with negative indent should stop the list:
        # - ```
        #  test
        break
      if marker_char isnt state.src.charCodeAt(start)
        continue
      if state.sCount[nextLine] - (state.blkIndent) >= 4
        # closing fence should be indented less than 4 spaces
        continue
      pos = start + 1
      while pos <= max
        if marker_str[(pos - start) % marker_len] isnt state.src[pos]
          break
        pos++
      # closing code fence must be at least as long as the opening one
      if Math.floor((pos - start) / marker_len) < marker_count
        pos++
        continue
      # make sure tail has spaces only
      pos -= (pos - start) % marker_len
      pos = state.skipSpaces(pos)
      if pos < max
        pos++
        continue
      # found!
      auto_closed = true
      break
    old_parent = state.parentType
    old_line_max = state.lineMax
    state.parentType = 'container'
    # this will prevent lazy continuations from ever going past our end marker
    state.lineMax = nextLine
    token = state.push('container_' + name + '_open', 'div', 1)
    token.markup = markup
    token.block = true
    token.info = params
    token.map = [
      startLine
      nextLine
    ]
    state.md.block.tokenize state, startLine + 1, nextLine
    token = state.push('container_' + name + '_close', 'div', -1)
    token.markup = state.src.slice(start, pos)
    token.block = true
    state.parentType = old_parent
    state.lineMax = old_line_max
    state.line = nextLine + (if auto_closed then 1 else 0)
    true
