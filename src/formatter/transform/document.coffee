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
      # write output
      token.out = switch token.nesting
        when 1
          "<!DOCTYPE html>#{nl}\
          <html>#{nl}\
          <head><title>#{token.data?.title}</title></head>#{nl}\
          <body>#{nl}\
          "
        when -1
          "</body>#{nl}\
          </html>"
