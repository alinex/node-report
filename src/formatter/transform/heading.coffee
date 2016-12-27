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

  text:
    format: 'text'
    type: 'heading'
    fn: (num, token) ->
      # make atx heading for first two levels
      if token.nesting is -1
        char = switch token.data.level
          when 1
            if @setup.ascii_art then '═' else '#'
          when 2
            if @setup.ascii_art then '━' else '='
          when 3
            if @setup.ascii_art then '╍' else '-'
          when 4
            if @setup.ascii_art then '┅' else '-'
          when 5
            if @setup.ascii_art then '─' else '-'
          when 6
            if @setup.ascii_art then '┄' else '-'
        token.out = "\n#{util.string.repeat char, @setup.width}\n"

  html:
    format: 'html'
    type: 'heading'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then "<h#{token.data.level}>"
        when -1 then "</h#{token.data.level}>\n"
        else "<h#{token.data.level} />\n"

  roff:
    format: 'roff'
    type: 'heading'
    fn: (num, token) ->
      if token.nesting isnt -1
        token.out = switch token.data.level
          when 1 then '.TH '
          when 2 then '.SH '
          else '.SS '
      else
        token.out = ''
      if token.nesting isnt 1
        token.out += '\n'
