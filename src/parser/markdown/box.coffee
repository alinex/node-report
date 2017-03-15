# markdown-it plugin to parse boxes
# =================================================


# Helper Methods
# ---------------------------------------

# @param {Object} token of paragraph_open
# @param {String} name attribute to be set
# @param {String} value for attribute
attrSet = (token, name, value) ->
  index = token.attrIndex name
  attr = [name, value]
  if index < 0 then token.attrPush attr
  else token.attrs[index] = attr


# Markdown-it extension
# ---------------------------------------

# @param {MarkdownIt} md object to add parser rule
module.exports = (md) ->
  md.block.ruler.before 'fence', 'box', (state, startLine, endLine, silent) ->
    console.log '-----', state
    console.log '-----', startLine, endLine, silent

    start = state.bMarks[startLine] + state.tShift[startLine]
    max = state.eMarks[startLine]
    # Check out for marker
    return false unless m = state.src.match /^:{3,}/
    marker_len = m[0].kength
    # Since start is found, we can report success here in validation mode
    return true if silent
    pos = start + marker_len
    markup = state.src.slice start, pos
    params = state.src.slice pos, max
    console.log markup, params
    # Search for the end of the block
    nextLine = startLine
    auto_closed = false
    loop
      nextLine++
      # unclosed block should be autoclosed by end of document.
      # also block seems to be autoclosed by end of parent
      break if nextLine >= endLine
      start = state.bMarks[nextLine] + state.tShift[nextLine];
      max = state.eMarks[nextLine];
      # non-empty line with negative indent should stop the list
      break if start < max and state.sCount[nextLine] < state.blkIndent
      continue unless m = state.src.match /^:{3,}/
      # closing fence should be indented less than 4 spaces
      continue unless state.sCount[nextLine] - state.blkIndent < 4
      # closing code fence must be at least as long as the opening one
      continue unless m[0].length >= marker_len
      # make sure tail has spaces only
#      pos -= pos - start
      pos = state.skipSpaces pos
      continue if pos < max
      # found!
      auto_closed = true
      break
    # start token
    token = state.push 'box_open', 'div', 1
    token.markup = markup
    token.block = true
    token.info = params
    token.map = [startLine, nextLine]
    # sub parsing
    old_parent = state.parentType
    old_line_max = state.lineMax
    state.parentType = 'box'
    # this will prevent lazy continuations from ever going past our end marker
    state.lineMax = nextLine
    state.md.block.tokenize state, startLine + 1, nextLine
    # end token
    token = state.push 'box_close', 'div', -1
    token.markup = state.src.slice start, pos
    token.block = true;
    # reset state
    state.parentType = old_parent
    state.lineMax = old_line_max
    state.line = nextLine + (auto_closed ? 1 : 0);
    console.log '-----', nextLine
    console.log '-----', state
    return true
