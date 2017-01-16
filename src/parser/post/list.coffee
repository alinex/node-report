# Text Phrases
# =================================================

# Transformer rules
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  concat:
    type: 'list'
    nesting: 1
    fn: (num, token) ->
      last = @get num - 1
      return unless last.type is 'list' and last.marker is token.marker
      @remove num
      @remove num-1
