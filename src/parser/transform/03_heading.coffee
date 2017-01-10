###
Headings
=================================================
This supports ATX headings and Setext headings like defined in http://spec.commonmark.org/.
###


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  empty:
    state: ['m-block']
    re: ///
      ^(\r?\n?    # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
        (\#{1,6}) # 2: level 1-6
      )           # end of start
      (           # 4: ending heading
        (?:\ +\#*)? # closing sequence with space and hashes (optional)
        \ *       # trailing spaces (optional)
        (?:\r?\n|$)  # end of line
      )
      ///
    fn: (m) ->
      level = m[2].length
      # opening
      @insert null,
        type: 'heading'
        data:
          level: level
        nesting: 1
        state: '-inline'
      # closing
      @index += m[0].length
      @insert null,
        type: 'heading'
        data:
          level: level
        nesting: -1
      # done
      m[0].length

  atx:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}   # indented by 1-3 spaces (optional)
        (\#{1,6}) # 2: level 1-6
        [\ \t]+   # at least one space
      )           # end of start
      ([^\n]*?)   # 3: text with trailing spaces (optional)
      (           # 4: ending heading
        (?:\ +\#*)? # closing sequence with space and hashes (optional)
        \ *       # trailing spaces (optional)
        (?:\n|$)  # end of line
      )
      ///
    fn: (m) ->
      level = m[2].length
      # opening
      @insert null,
        type: 'heading'
        data:
          level: level
        nesting: 1
        state: '-inline'
      # parse subtext
      @index += m[1].length
      @lexer m[3]
      # closing
      @index += m[4].length
      @insert null,
        type: 'heading'
        data:
          level: level
        nesting: -1
        closed: true
      # done
      m[0].length

  setext:
    state: ['m-block']
    re: ///
      ^(\n?       # 1: start of line
        \ {0,3}       # indented by 1-3 spaces (optional)
      )           # end of start
      (           # 2: text with trailing spaces (optional)
        (?:\r?\n[^\n] # containing only single newlines
        |[^\r\n])+?   # and otehr characters
      )           # end of text
      (           # 3: type of heading
        \n[\ \t]{0,3} # underline up to 3 spaces indent
        [=-]{1,}      # underline characters 1+
      )           # end of underline
      (           # 4: ending heading
        [\ \t]*       # trailing spaces (optional)
        (?:\n|$)      # end of line
      )
      ///
    fn: (m) ->
      level = switch m[3].trim()[0]
        when '=' then 1
        when '-' then 2
      # opening
      @insert null,
        type: 'heading'
        data:
          level: level
        nesting: 1
        state: '-inline'
      # parse subtext
      @index += m[1].length
      @lexer m[2]
      # closing
      @index += m[4].length
      @insert null,
        type: 'heading'
        data:
          level: level
        nesting: -1
      # done
      m[0].length
