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
# count number of blockquotes in parents
# color yellow, white, gray
#      color = 1
#      for t in @tokens.parents
#      color++ if @tokens.parents
      marker = chalk.bold if @setup.ascii_art then '│' else '>'
      prev = @tokens.get num - 1
      token.collect = token.collect
      .replace /^\n|\n$/g, ''
      .replace /\n/g, "\n#{marker} "
      token.collect = "#{marker} #{token.collect}\n"
      token.collect = "\n#{token.collect}" unless prev.hidden
