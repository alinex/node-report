

module.exports = (md, options) ->
  console.log md, options


return

module.exports = (md, name, options) ->

  validateDefault = (params) ->
    params.trim().split(' ', 2)[0] == name

  renderDefault = (tokens, idx, _options, env, self) ->
    # add a class to the opening tag
    if tokens[idx].nesting == 1
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
    if marker_char != state.src.charCodeAt(start)
      return false
    # Check out the rest of the marker string
    #
    pos = start + 1
    while pos <= max
      if marker_str[(pos - start) % marker_len] != state.src[pos]
        break
      pos++
    marker_count = Math.floor((pos - start) / marker_len)
    if marker_count < min_markers
      return false
    pos -= (pos - start) % marker_len
    markup = state.src.slice(start, pos)
    params = state.src.slice(pos, max)
    if !validate(params)
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
      if marker_char != state.src.charCodeAt(start)
        continue
      if state.sCount[nextLine] - (state.blkIndent) >= 4
        # closing fence should be indented less than 4 spaces
        continue
      pos = start + 1
      while pos <= max
        if marker_str[(pos - start) % marker_len] != state.src[pos]
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

  options = options or {}
  min_markers = 3
  marker_str = options.marker or ':'
  marker_char = marker_str.charCodeAt(0)
  marker_len = marker_str.length
  validate = options.validate or validateDefault
  render = options.render or renderDefault
  md.block.ruler.before 'fence', 'container_' + name, container, alt: [
    'paragraph'
    'reference'
    'blockquote'
    'list'
  ]
  md.renderer.rules['container_' + name + '_open'] = render
  md.renderer.rules['container_' + name + '_close'] = render
  return
