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
      ^\n?                # start with possible newlines
      (\ {0,3})           # 1: indented by 1-3 spaces
      (?:([-_*])[\ \t]*)  # 2: first line character with possible spaces
      (?:\2[\ \t]*){2,}   # two or more of the same characters
      \ *                 # optional spaces at the end
      (?:\n|$)            # end of line
      ///
    fn: (m) ->
      last = @get()
      if last.type is 'item'
        return if m[1].length >= last.depth
        # break lazy in item
        @autoclose last.parent.level - 1
      @insert null,
        type: 'thematic_break'
      # done
      m[0].length
