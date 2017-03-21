# markdown-it plugin to parse boxes
# =================================================


# Setup
# -------------------------------------------
TOC_REGEXP = ///
  ^@\[toc\]
  (?:\((?:\s+)?([^\)]+)(?:\s+)?\)?)?
  \s*?$
  ///im


# Init plugin in markdown-it
# -------------------------------------------

module.exports = (md) ->
  # add parser rules
  md.block.ruler.before 'paragraph', 'toc', parser


# Parser
# -------------------------------------------
parser = (state, startLine, endLine, silent) ->
  pos = state.bMarks[startLine] + state.tShift[startLine]
  max = state.eMarks[startLine]
  # if it's indented more than 3 spaces, it should be a code block
  return false if state.sCount[startLine] - state.blkIndent >= 4
  # trivial rejections
  return false if state.src.charCodeAt(pos) isnt 0x40 # @
  return false if state.src.charCodeAt(pos + 1) isnt 0x5B # [
  # detect TOC markdown
  return false unless m = state.src.match TOC_REGEXP

  return true if silent

  state.line = startLine + 1
  token        = state.push 'toc', 'toc', 0
  token.map    = [startLine, state.line]
  token.markup = '@[toc]'
  token.content = m[1]
  return true
