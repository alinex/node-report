###
Inline Text
=================================================
Text may also contain some other inline markup.

> In the post optimization masking of characters (used to prevent interpreting special
> chars as markdown) is replaced.
###


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  char:
    state: ['m-inline', 'mh-inline', 'h-inline', 'cache']
    re: /^./
    fn: (m) ->
      last = @tokens[@tokens.length-1]
      if last.type is 'text'
        last.data.text += m[0]
      else
        @add
          type: 'text'
          data:
            text: m[0]
      @index++
      # done processing
      m[0].length
