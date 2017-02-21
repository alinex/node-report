# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'link'
    fn: (num, token) ->
      # escape previous exclamation mark to prevent image syntax
      prev = @tokens.get num - 1
      prev.out = prev.out.replace /!$/, '\\!'
