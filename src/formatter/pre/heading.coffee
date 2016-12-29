# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  # Add title to document element from first heading
  title:
    format: ['html', 'latex']
    type: 'heading'
    nesting: 1
    fn: (num, token) ->
      return if @tokens[0].data?.title
      # get title
      title = ''
      for n in [++num..@tokens.length - 1]
        t = @get n
        break if t.level is token.level
        title += t.data.text if t.data?.text
      @tokens[0].data ?= {}
      @tokens[0].data.title = title
