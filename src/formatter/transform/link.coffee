# Link
# =================================================

chalk = require 'chalk'
util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'link'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      switch token.nesting
        when 1
          util.extend token,
            html:
              href: token.href
          token.html.title = token.title if token.title
          token.out = "<a#{@htmlAttribs token}>"
        when -1
          token.out = "</a>#{nl}"

  md:
    format: ['md']
    type: 'link'
    fn: (num, token) ->
      if token.nesting is 1
        token.out = '['
      else
        [_, start] = @tokens.findStart num, token
        if start.reference
          token.out = "][#{start.reference}]"
        else
          uri = if start.href.match /[()]/g then "<#{start.href}>" else start.href
          token.out = "](#{uri}"
          token.out += " \"#{start.title.replace /(")/g, '\\$1'}\"" if start.title
          token.out += ')'

  other:
    format: ['text']
    type: 'link'
    fn: (num, token) ->
      return unless token.nesting is -1
      [_, start] = @tokens.findStart num, token
      uri = if start.href.match /[()]/g then "<#{start.href}>" else start.href
      token.out = if @setup.ansi_escape
        chalk = new chalk.constructor {enabled: true}
        ' ' + chalk.underline.gray uri
      else
        " (#{uri})"
