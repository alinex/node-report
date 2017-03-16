# markdown-it plugin to parse boxes
# =================================================


# Setup
# -------------------------------------------
MARKER = ':'.charCodeAt 0
MINLEN = 3


# Init plugin in markdown-it
# -------------------------------------------

module.exports = (md) ->
  # add parser rules
  md.block.ruler.before 'fence', 'box', parser, ['paragraph', 'reference', 'blockquote', 'list']


# Parser
# -------------------------------------------

parser = (state, startLine, endLine, silent) ->
  endLineContainer = endLine
  pos = state.bMarks[startLine] + state.tShift[startLine]
  max = state.eMarks[startLine]
  return false if pos + MINLEN > max
  return false unless MARKER is state.src.charCodeAt pos
  # scan marker length
  mem = pos
  pos = state.skipChars pos, MARKER
  len = pos - mem
  # at least 3 characters to start with
  return false if len < MINLEN
  markup = state.src.slice mem, pos
  params = state.src.slice(pos, max).trim()
  # Since start is found, we can report success here in validation mode
  return false if silent
  # start token
  token = state.push 'container_open', 'div', 1
  token.block = true
  # start parsing content
  oldParent = state.parentType
  oldLineMax = state.lineMax
  loop
    # search end of block
    nextLine = startLine
    endLine = endLineContainer
    haveEndMarker = false
    loop
      nextLine++
      # unclosed block should be autoclosed by end of document.
      # also block seems to be autoclosed by end of parent
      break if nextLine >= endLine
      pos = mem = state.bMarks[nextLine] + state.tShift[nextLine]
      max = state.eMarks[nextLine]
      # non-empty line with negative indent should stop the list:
      # - :::
      #  test
      break if pos < max and state.sCount[nextLine] < state.blkIndent
      continue unless state.src.charCodeAt(pos) is MARKER
      # closing fence should be indented less than 4 spaces
      continue if state.sCount[nextLine] - state.blkIndent >= 4
      pos = state.skipChars(pos, MARKER)
      # closing fence must be at least as long as the opening one
      continue if pos - mem < len
      haveEndMarker = true
      # found!
      break
    closeParams = if haveEndMarker then state.src.slice(pos, max).trim() else ''
    # If a fence has heading spaces, they should be removed from its inner block
    len = state.sCount[startLine]
    endLine = nextLine + if haveEndMarker then 1 else 0
    # start token
    token = state.push 'box_open', 'div', 1
    token.block = true
    token.markup = markup
    token.info = params
    token.content = state.getLines startLine + 1, nextLine, len, true
    token.map = [startLine, endLine]
    # sub parsing
    state.parentType = 'box'
    # this will prevent lazy continuations from ever going past our end marker
    state.lineMax = nextLine
    state.md.block.tokenize state, startLine + 1, nextLine
    # end token
    token = state.push 'box_close', 'div', -1
    token.markup = markup
    token.block = true
    # reset state
    state.parentType = oldParent
    state.lineMax = oldLineMax
    endLine++ unless haveEndMarker
    # go one line back if multibox entry
    state.line = endLine
    startLine = state.line
    break unless closeParams.length
    markup = state.src.slice mem, pos
    params = state.src.slice(pos, max).trim()
    startLine--
  # end token
  token = state.push 'container_close', 'div', -1
  token.block = true
  return true
