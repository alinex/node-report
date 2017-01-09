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
    state: ['m-block', 'mh-block']
    re: /^\s*\n/ # multiple empty lines
    fn: (m) ->
      # check for concatenating
      last = @get -1
      last.closed = true if last
      # done
      @index += m[0].length
      m[0].length
