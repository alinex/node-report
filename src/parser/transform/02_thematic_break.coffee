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
    state: ['m-block']
    re: ///
      ^\r?\n?             # start with possible newlines
      \ {0,3}             # indented by 1-3 spaces
      (?:([-_*])[\ \t]*)  # 1: first line character with possible spaces
      (?:\1[\ \t]*){2,}   # two or more of the same characters
      \ *                 # optional spaces at the end
      (?:\r?\n|$)         # end of line
      ///
    fn: (m) ->
      @insert null,
        type: 'thematic_break'
      # done
      @index += m[0].length
      m[0].length
