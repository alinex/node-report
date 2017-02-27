# Headings
# =================================================


uslug = require 'uslug'


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  # Add title to document element from first heading
  title:
    format: 'md'
    type: 'link'
    nesting: 1
    fn: (num, token) ->
      return unless @setup.use_references and token.href?.length
      doc = @tokens.data[0]
      # find reference
      doc.linkNames ?= {}
      doc.links ?= {}
      return if token.reference = doc.links["#{token.href} #{token.title}"]
      # add reference
      name = uslug(
        token.href.toLowerCase()
        .replace /^(\/|\w+:\/+|mailto:)/i, ''
        .replace /%[a-f0-9]{2}/g, ''
        .replace /[@\/].*|:\d+/g, ''
        .replace /^www\./, ''
      )
      name = 'link' unless name.length
      if name in Object.keys doc.linkNames
        n = 0
        loop
          break unless name + ++n in Object.keys doc.linkNames
        name += n
      doc.linkNames[name] = [token.href, token.title]
      doc.links["#{token.href} #{token.title}"] = [name]
      token.reference = name
