# Headings
# =================================================


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  pdf: (content, cb) ->
    console.log 'CONVERT TO PDF'
    cb null, content
