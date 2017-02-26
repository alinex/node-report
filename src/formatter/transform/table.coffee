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
        when 1 then "<table>#{nl}"
        when -1 then "</table>#{nl}"
        else "<table />#{nl}"

  html_thead:
    format: 'html'
    type: 'thead'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<thead>#{nl}"
        when -1 then "</thead>#{nl}"
        else "<thead />#{nl}"

  html_tbody:
    format: 'html'
    type: 'tbody'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<tbody>#{nl}"
        when -1 then "</tbody>#{nl}"
        else "<tbody />#{nl}"

  html_tr:
    format: 'html'
    type: 'tr'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<tr>#{nl}"
        when -1 then "</tr>#{nl}"
        else "<tr />#{nl}"

  html_th:
    format: 'html'
    type: 'th'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<th>"
        when -1 then "</th>#{nl}"
        else "<th />#{nl}"

  html_td:
    format: 'html'
    type: 'td'
    fn: (num, token) ->
      nl = if @setup.compress then '' else '\n'
      token.out = switch token.nesting
        when 1 then "<td>"
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
    format: ['md', 'text']
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
