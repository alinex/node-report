###
Headings
=================================================
###


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  md:
    state: ['m-block', 'mh-block']
    re: ///
      ^\n*                # start with possible newline
      \ {0,3}             # indented by 1-3 spaces
      (?:([-_*])[\ \t]*)  # 1: first line character with possible spaces
      (?:\1[\ \t]*){2,}   # two or more of the same characters
      \ *                 # optional spaces at the end
      (?:\n|$)            # end of line
      ///
    fn: (m) ->
      @add
        type: 'thematic_break'
      # done
      m[0].length
