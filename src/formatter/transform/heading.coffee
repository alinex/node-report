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
          else
            # mask trailing hashes in last text bloxk
            if last = @get -1
              if last.type is 'text'
                last.data.text.replace /\#$/, '\\#'
            # add newline
            "\n"
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
      # collect attributes
      attrib = ''
      if token.html?
        console.log token
        attrib = ' ' + Object.keys(token.html).map (e) -> "#{e}=\"#{token.html[e]}\""
        .join ' '
      # write tag
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<h#{token.data.level}#{attrib}>"
        when -1 then "</h#{token.data.level}>#{nl}"
        else "<h#{token.data.level}#{attrib} />#{nl}"

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

  latex:
    format: 'latex'
    type: 'heading'
    nesting: 1
    fn: (num, token) ->
      token.out = "\n   \\maketitle\n   "

  rtf:
    format: 'rtf'
    type: 'heading'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1
          "\\b{"
        when -1
          "}"
