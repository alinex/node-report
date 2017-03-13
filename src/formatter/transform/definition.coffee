# Headings
# =================================================


util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'dl'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<dl#{@htmlAttribs token}>#{nl}"
        when -1 then "</dl>#{nl}"
        else "<dl#{@htmlAttribs token} />#{nl}"

  html_dt:
    format: 'html'
    type: 'dt'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<dt#{@htmlAttribs token}>"
        when -1 then "</dt>#{nl}"
        else "<dt#{@htmlAttribs token} />#{nl}"

  html_dd:
    format: 'html'
    type: 'dd'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<dd#{@htmlAttribs token}>"
        when -1 then "</dd>#{nl}"
        else "<dd#{@htmlAttribs token} />#{nl}"

  md:
    format: ['md', 'text']
    type: 'dl'
    nesting: 1
    fn: (num, token) ->
      token.out = '\n'

  md_dt:
    format: ['md', 'text']
    type: 'dt'
    fn: (num, token) ->
      token.out = '\n'

  md_dd:
    format: ['md', 'text']
    type: 'dd'
    nesting: 1
    fn: (num, token) ->
      token.out = '  : '
