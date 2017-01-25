# Text Paragraph
# =================================================


Config = require 'alinex-config'


# Transformer rules

#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  text:
    state: ['m-block']
    re: ///
      ^\n?        # start of line
      (\ {0,3})   # 1: indented by 1-3 spaces (optional)
      ([`~]{3,})  # 2: fence characters
      (?:\ +      # info part
        (\w+)       # 3: language
      )?          # optional
      [\ \t]*\n   # ignore whitespace after this
      (           # 4: content
        [\s\S]*?  # all to end of line
      )           # end content
      (?:         # ending
        \n?       # possible newline after text
        \ {0,3}   # indention of one to three spaces
        \2[^\n]*  # marker
        (?:\n|$)  # end of line
      |$          # or end of document
      )
      /// # one line
    fn: (m) ->
      # content with removed indention of marker
      code = m[4]
      if m[1]
        re = new RegExp "(^|\n) {0,#{m[1].length}}", 'g'
        code = code.replace re, '$1'
      # opening
      @insert null,
        type: 'code'
        nesting: 1
        state: '-text'
        data:
          language: Config.get('/report/code/language')[m[3]] ? m[3] ? 'text'
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
      (?:\ +      # info part
        (\w+)       # 1: language
      )?          # optional
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
