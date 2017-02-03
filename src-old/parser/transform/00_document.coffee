###
Headings
=================================================
This supports ATX headings and Setext headings like defined in http://spec.commonmark.org/.
###


# Transformer rules
# ----------------------------------------------
#
# @type {Object<Transformer>} rules to transform text into tokens
module.exports =

  empty:
    state: ['m-doc']
    re: /./
    fn: ->
      # opening
      @insert null,
        type: 'document'
        nesting: 1
        state: '-block'
