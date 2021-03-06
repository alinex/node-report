###
Blank Line
=================================================
Blank lines between block-level elements are not being parsed in any element but
will definetly close the previous block to not continue.
###


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  empty:
    state: ['m-block']
    re: /^\s*(?:\n|$)/ # multiple empty lines
    fn: (m) ->
      # check for concatenating
      last = @get()
      last.closed = true if last
      # done
      m[0].length
