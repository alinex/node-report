# Include
# =================================================


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
      \[\#INCLUDE\]\(
      ([^\n]+)    # 2: source URL
      \)[^\n]*
      (\n|$)      # 3: end of line
      /// # one line
    fn: (m) ->
      url = m[2]
      # opening
      @insert null,
        type: 'include'
        content: url
      # done
      m[0].length
