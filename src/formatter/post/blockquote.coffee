# Headings
# =================================================


chalk = require 'chalk'



# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md:
    format: ['md']
    type: 'blockquote'
    fn: (num, token) ->
      prev = @tokens.get num - 1
      token.collect = token.collect
      .replace /^\n|\n$/g, ''
      .replace /\n/g, '\n> '
      token.collect = "> #{token.collect}\n"
      token.collect = "\n#{token.collect}" unless prev.hidden

  text:
    format: ['text']
    type: 'blockquote'
    fn: (num, token) ->
      chalk = new chalk.constructor {enabled: @setup.ansi_escape ? false}
      # color dependent of depth
      depth = 1
      p = token
      while p = p.parent
        depth++ if p.type is 'blockquote'
      color = switch depth
        when 1 then chalk.bold.yellow
        when 2 then chalk.bold.white#
        when 3 then chalk.bold.gray
        else chalk.grey
      # add tokens
      marker = color if @setup.ascii_art then '│' else '>'
      prev = @tokens.get num - 1
      token.collect = token.collect
      .replace /^\n|\n$/g, ''
      .replace /\n/g, "\n#{marker} "
      token.collect = "#{marker} #{token.collect}\n"
      token.collect = "\n#{token.collect}" unless prev.hidden
