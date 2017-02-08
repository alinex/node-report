###
Text Format: fixed
=================================================
###


# ----------------------------------------------
# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  backquote:
    state: ['m-inline']
    re: ///
      ^(`+)                # 1: start MARKER
      (?=[^`])             # not followed by backquote
      ([\s\S]*?[^`])       # 2: content
      \1                   # end MARKER
      (?=[^`]|$)           # not followed by backquote
      ///
    fn: (m) ->
      # opening
      @insert null,
        type: 'fixed'
        nesting: 1
      # parse subtext
      if m[2]
        @insert null,
          type: 'text'
          data:
            text: m[2].trim()
      # closing
      @insert null,
        type: 'fixed'
        nesting: -1
      # done
      m[0].length
