# Image
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  other:
    format: ['md', 'text']
    type: 'image'
    fn: (num, token) ->
      # recollect with substitutions in all but image or link elements
      token.collect = ''
      n = num
      loop
        t = @tokens.get ++n
        break if t.level is token.level # reached end of sub elements
        if t.level is token.level + 1 # only one level deeper
          # collect data
          data = ''
          data += t.out if t.out
          data += t.collect if t.collect
          # mask brackets if not from other link or image
          data = data.replace /([\[\]])/g, '\\$1' unless t.type in ['image', 'link']
          token.collect += data
