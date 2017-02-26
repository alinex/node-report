# Imgaes
# =================================================


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
      # replace with autolink
      doc = @tokens.data[0]
      link = doc.linkNames[token.reference]
      return if link[1]
      if token.collect is link[0] \
      or "mailto:#{token.collect}" is link[0]
        token.out = '<'
        end.out = '>'
