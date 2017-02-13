# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'fixed'
    fn: (num, token) ->
      marker = '`'
      loop
        break unless ~token.collect.indexOf marker
        marker += '`'
      token.out = marker
      token.collect = ' ' unless token.collect
      token.collect = token.collect
      .replace /^`/, ' `'
      .replace /`$/, '` '
      token.collect = token.collect + marker
