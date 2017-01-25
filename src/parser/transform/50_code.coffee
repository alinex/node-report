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
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
      )           # end of start
      ([`~]{3,})  # 2: fence characters
      (?:\ +
        (\w+)     # 3: language
      )?
      [\ \t]*\n
      (           # 4: content
        [\s\S]*?  # all to end of line
      )           # end content
      (?:
        \2[^\n]*  # normal ending
        (?:\n|$)  # end of line
      |$          # end of document
      )
      /// # one line
    fn: (m) ->
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
          text: m[4]
      @insert null,
        type: 'code'
        nesting: -1
        state: '-text'
      # done
      m[0].length

  empty:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
      )           # end of start
      ([`~]{3,})  # 2: fence characters
      (?:\ +
        (\w+)     # 3: language
      )?
      $           # end of document
      /// # one line
    fn: (m) ->
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
          text: ''
      @insert null,
        type: 'code'
        nesting: -1
        state: '-text'
      # done
      m[0].length
