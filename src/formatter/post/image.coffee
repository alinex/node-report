# Imgaes
# =================================================

util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: 'md'
    type: 'image'
    fn: (num, token) ->
      return unless token.reference
      # shorten reference links if possible
      [_, end] = @tokens.findEnd num, token
      end.out = ']' if end.out is "][#{token.collect.toLowerCase()}]"

  html:
    format: 'html'
    type: 'image'
    fn: (num, token) ->
      token.collect = util.string.htmlEncode token.collect
