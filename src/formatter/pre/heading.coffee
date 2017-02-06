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
      for n in [num+1..@tokens.data.length - 1]
        t = @tokens.get n
        break if t.level is token.level
        title += t.content if t.content
      title = title.trim()
      # add link id
      unless token.html?.id
#        lname = uslug "h#{token.heading}-#{title}"
        lname = uslug title
        i = 0
        loop
          add = if i then "-#{i}" else ''
          break unless @linkNames[lname + add]
          i++
        lname += add
        @linkNames[lname] = token
        token.html ?= {}
        token.html.id ?= lname
      # store as document title
      unless @tokens.data[0].title
        @tokens.data[0].title = title.trim()
