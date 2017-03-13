# Table
# =================================================


chalk = require 'chalk'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  md_dt:
    format: 'text'
    type: 'dt'
    fn: (num, token) ->
      chalk = new chalk.constructor {enabled: Boolean @setup.ansi_escape}
      token.collect = chalk.bold token.collect

  md_dd:
    format: 'md'
    type: 'dd'
    fn: (num, token) ->
      token.collect = token.collect
      .replace /^\n/, ''
      .replace /\n([^\n])/g, '\n    $1'
