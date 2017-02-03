# Headings
# =================================================


# Post rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  # Add title to document element from first heading
  title:
    type: 'heading'
    nesting: 1
    fn: (num, token) ->
      token.content = token.content.replace /\ $/, '' # remove last space
