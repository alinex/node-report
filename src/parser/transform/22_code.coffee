# Text Paragraph
# =================================================


Config = require 'alinex-config'

SPACE_SPLIT = ///
  (?:
    [^\s"']+  # anything that's not a space or a double-quote
  | "         # or opening double-quote
    (?:\\"    # masked quote
    |[^"]     # or other characters but no double quote
    )*        # optional
    "         # closing double-quote
  | '         # or opening single-quote
    (?:\\'    # masked quote
    |[^']     # or other characters but no single quote
    )*        # optional
    '         # closing single-quote
  )+          # each match is one or more of the things described in the group
  ///

splitInfo = (text) -> return text.match SPACE_SPLIT

# Transformer rules

#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  oneliner:
    state: ['m-block']
    re: ///
      ^\n?        # start of line
      (\ {0,3})   # 1: indented by 1-3 spaces (optional)
      (([`~]){3,})  # 2: fence characters - 3: single character
      (           # 4: content
        [^\n`]+?       # all to end of line
      )           # end content
      (?:         # ending
        \2(\3)*   # end marker
        [\ \t]*   # possible whitespace
        (?:\n|$)  # end of line
      |$          # or end of document
      )
      /// # one line
    fn: (m) ->
      # content with removed indention of marker
      code = m[4].trim()
      if m[1]
        re = new RegExp "(^|\n) {0,#{m[1].length}}", 'g'
        code = code.replace re, '$1'
      # get language
      language = 'text'
      # opening
      @insert null,
        type: 'code'
        nesting: 1
        state: '-text'
        data:
          language: language
      @insert null,
        type: 'text'
        data:
          text: code
      @insert null,
        type: 'code'
        nesting: -1
        state: '-text'
      # done
      m[0].length

  text:
    state: ['m-block']
    re: ///
      ^\n?        # start of line
      (\ {0,3})   # 1: indented by 1-3 spaces (optional)
      (([`~]){3,})  # 2: fence characters - 3: single character
      (?:[\ \t]*  # info part
        ([^`~\ \t\n].*?)     # 4: info
      )?          # optional
      [\ \t]*\n   # ignore whitespace after this
      (           # 5: content
        [\s\S]*?  # all to end of block
      )           # end content
      (?:         # ending
        \n?       # possible newline after text
        \ {0,3}   # indention of one to three spaces
        \2(\3)*   # end marker
        [\ \t]*   # possible whitespace
        (?:\n|$)  # end of line
      |$          # or end of document
      )
      /// # one line
    fn: (m) ->
      # content with removed indention of marker
      code = m[5]
      if m[1]
        re = new RegExp "(^|\n) {0,#{m[1].length}}", 'g'
        code = code.replace re, '$1'
      # get language
      language = unless m[4]
        'text'
      else
        info = splitInfo m[4]
        language = Config.get('/report/code/language')[info[0]] ? info[0] ? 'text'
      # opening
      @insert null,
        type: 'code'
        nesting: 1
        state: '-text'
        data:
          language: language
      @insert null,
        type: 'text'
        data:
          text: code
      @insert null,
        type: 'code'
        nesting: -1
        state: '-text'
      # done
      m[0].length

  empty:
    state: ['m-block']
    re: ///
      ^\n?        # start of line
      \ {0,3}     # indented by 1-3 spaces (optional)
      [`~]{3,}    # fence characters
      $           # end of document
      /// # one line
    fn: (m) ->
      # opening
      @insert null,
        type: 'code'
        nesting: 1
        state: '-text'
        data:
          language: Config.get('/report/code/language')[m[1]] ? m[1] ? 'text'
      @insert null,
        type: 'text'
        data:
          text: ''
      @insert null,
        type: 'code'
        nesting: -1
        state: '-text'
      # done
      m[0].length
