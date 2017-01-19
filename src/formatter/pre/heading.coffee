# Headings
# =================================================


uslug = require 'uslug'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  # Add title to document element from first heading
  title:
    format: ['html', 'latex', 'roff']
    type: 'heading'
    nesting: 1
    fn: (num, token) ->
      # get title
      title = ''
      for n in [++num..@tokens.length - 1]
        t = @get n
        break if t.level is token.level
        title += t.data.text if t.data?.text
      title = title.trim()
      # add link id
      unless token.html?.id
#        lname = uslug "h#{token.data.level}-#{title}"
        lname = uslug title
        i = 0
        loop
          add = if i then "-#{i}" else ''
          break unless @linkNames[lname + add]
          i++
        lname += add
        @linkNames[lname] = token
        token.html ?= if token.data.html then util.clone token.data.html else {}
        token.html.id ?= lname
      # store as document title
      unless @tokens[0].data?.title
        @tokens[0].data ?= {}
        @tokens[0].data.title = title.trim()
