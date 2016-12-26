# Headings
# =================================================

util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  markdown:
    format: 'md'
    type: 'heading'
    fn: (num, token) ->
      # make atx heading for first two levels
      if token.nesting is -1
        token.out = switch token.data.level
          when 1 then "\n#{util.string.repeat '=', @setup.width}\n"
          when 2 then "\n#{util.string.repeat '-', @setup.width}\n"
      # setext headings for the rest
      else if token.data.level > 2
        token.out = "\n#{util.string.repeat '#', token.data.level} "

  html:
    format: 'html'
    type: 'heading'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then "<h#{token.data.level}>"
        when -1 then "</h#{token.data.level}>"
        else "<h#{token.data.level} />"
