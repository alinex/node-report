# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'document'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      # get title
      title = ''
      collect = false
      for t in @tokens
        if t.type is 'heading'
          break if collect
          collect = true
          continue
        title += t.data.text if t.data?.text
      # write output
      token.out = switch token.nesting
        when 1
          "<!DOCTYPE html>#{nl}\
          <html>#{nl}\
          <head><title>#{title}</title></head>#{nl}\
          <body>#{nl}\
          "
        when -1
          "</body>#{nl}\
          </html>"
