# Headings
# =================================================


util = require 'alinex-util'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'table'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<table#{@htmlAttribs token}>#{nl}"
        when -1 then "</table>#{nl}"
        else "<table#{@htmlAttribs token} />#{nl}"

  html_thead:
    format: 'html'
    type: 'thead'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<thead#{@htmlAttribs token}>#{nl}"
        when -1 then "</thead>#{nl}"
        else "<thead#{@htmlAttribs token} />#{nl}"

  html_tbody:
    format: 'html'
    type: 'tbody'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<tbody#{@htmlAttribs token}>#{nl}"
        when -1 then "</tbody>#{nl}"
        else "<tbody#{@htmlAttribs token} />#{nl}"

  html_tr:
    format: 'html'
    type: 'tr'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<tr#{@htmlAttribs token}>#{nl}"
        when -1 then "</tr>#{nl}"
        else "<tr#{@htmlAttribs token} />#{nl}"

  html_th:
    format: 'html'
    type: 'th'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1
          util.extend token.html,
            style: ["text-align:#{token.align};"]
          "<th#{@htmlAttribs token}>"
        when -1 then "</th>#{nl}"
        else "<th />#{nl}"

  html_td:
    format: 'html'
    type: 'td'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1
          util.extend token.html,
            style: ["text-align:#{token.parent.parent.parent.align[token.col]};"]
          "<td#{@htmlAttribs token}>"
        when -1 then "</td>#{nl}"
        else "<td />#{nl}"

  md_tr:
    format: ['md', 'text']
    type: 'tr'
    nesting: -1
    fn: (num, token) ->
      token.out = '|\n'

  md_td:
    format: ['md', 'text']
    type: 'td'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then '| '
        when -1 then ' '

  md_th:
    format: ['md', 'text']
    type: 'th'
    fn: (num, token) ->
      token.out = switch token.nesting
        when 1 then '| '
        when -1 then ' '

  md_thead:
    format: 'md'
    type: 'thead'
    nesting: -1
    fn: (num, token) ->
      token.out = ''
      for i in [1..token.parent.col]
        token.out += switch token.parent.align[i]
          when 'left' then '|:- '
          when 'center' then '|:-:'
          when 'right' then '| -:'
          else '| - '
      token.out += '|\n'

  text_thead:
    format: ['text']
    type: 'thead'
    fn: (num, token) ->
      token.out = ''
      for i in [1..token.parent.col]
        token.out += switch token.parent.align[i]
          when 'left' then '|---'
          when 'center' then '|---'
          when 'right' then '|---'
          else '|---'
      token.out += '|\n'

  text_tbody:
    format: ['text']
    type: 'tbody'
    nesting: -1
    fn: (num, token) ->
      token.out = ''
      for i in [1..token.parent.col]
        token.out += switch token.parent.align[i]
          when 'left' then '|---'
          when 'center' then '|---'
          when 'right' then '|---'
          else '|---'
      token.out += '|\n'
