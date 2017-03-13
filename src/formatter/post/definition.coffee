# Table
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md_dd:
    format: 'md'
    type: 'dd'
    fn: (num, token) ->
      token.collect = token.collect
      .replace /^\n/, ''
      .replace /\n([^\n])/g, '\n    $1'
