# Style settings
# =================================================


# Implementation
# ----------------------------------------------------

# Post rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  html:
    format: 'html'
    type: 'style'
    fn: (num, token) ->
      return if token.format isnt 'html'
      console.log '-----', token.content
      @style ?= {}
