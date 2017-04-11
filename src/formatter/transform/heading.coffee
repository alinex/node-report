# Headings
# =================================================

chalk = require 'chalk'
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
      token.out = if token.nesting is -1
        switch token.heading
          when 1 then "\n#{util.string.repeat '=', @setup.width}\n"
          when 2 then "\n#{util.string.repeat '-', @setup.width}\n"
          else
            # mask trailing hashes in last text block
            if last = @tokens.get num - 1
              if last.type is 'text'
                last.out = last.out.replace /(\#+)$/, '\\$1'
            # add newline
            "\n"
      # setext headings for the rest
      else if token.heading > 2
        "\n#{util.string.repeat '#', token.heading} "
      else
        "\n\n"

  text:
    format: 'text'
    type: 'heading'
    fn: (num, token) ->
      chalk = new chalk.constructor {enabled: @setup.ansi_escape ? false}
      color = if token.heading > 2 then chalk.white else chalk.yellow
      marker = color.bold('?').split /\?/
      # make atx heading for first two levels
      if token.nesting is 1
        token.out = marker[0]
      else
        char = switch token.heading
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
        token.out = marker[1] + color "\n#{util.string.repeat char, @setup.width}\n"

  html:
    format: 'html'
    type: 'heading'
    fn: (num, token) ->
      # write tag
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<h#{token.heading}#{@htmlAttribs token}>"
        when -1 then "</h#{token.heading}>#{nl}"
        else "<h#{token.heading}#{attrib} />#{nl}"

  roff:
    format: 'roff'
    type: 'heading'
    fn: (num, token) ->
      token.out = switch token.heading
        when 1
          if token.nesting is 1 then '.SH "NAME"\n\\fB' else '\\fR\n'
        when 2
          if token.nesting is 1 then '.SH ' else '\n'
        else
          if token.nesting is 1 then '.SS ' else '\n'

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
