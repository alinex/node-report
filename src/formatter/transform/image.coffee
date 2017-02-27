# Image
# =================================================


chalk = require 'chalk'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'image'
    fn: (num, token) ->
      switch token.nesting
        when 1
          token.out = "<img src=\"#{token.src}\""
          token.out += " title=\"#{token.title}\"" if token.title
          token.out += " alt=\""
        when -1
          token.out = "\" />"

  md:
    format: ['md']
    type: 'image'
    fn: (num, token) ->
      if token.nesting is 1
        token.out = '!['
      else
        [_, start] = @tokens.findStart num, token
        if start.reference
          token.out = "][#{start.reference}]"
        else
          uri = if start.src.match /[()]/g then "<#{start.src}>" else start.src
          token.out = "](#{uri}"
          token.out += " \"#{start.title.replace /(")/g, '\\$1'}\"" if start.title
          token.out += ')'

  other:
    format: ['text']
    type: 'image'
    fn: (num, token) ->
      chalk = new chalk.constructor {enabled: @setup.ansi_escape ? false}
      marker = chalk.gray('?').split /\?/
      token.out = if token.nesting is 1 then "#{marker[0]}[" else "]#{marker[1]}"
