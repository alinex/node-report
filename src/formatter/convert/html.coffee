# Convert HTML
# =================================================

webshot = null # load on demand


screenshot = (content, type, setup, cb) ->
  webshot ?= require 'webshot'
  webshot content,
    siteType: 'html'
    streamType: type
    windowSize:
      width: setup.width ? 800
      height: setup.height ? 600
    captureSelector: setup.capture ? '#page'
    renderDelay: 1000
  , (err, stream) ->
    return cb err if err
    buffer = ''
    stream.on 'data', (data) -> buffer += data.toString 'binary'
    stream.on 'end', -> cb null, buffer


# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  png: (content, cb) -> screenshot content, 'png', @setup.convert, cb
  jpg: (content, cb) -> screenshot content, 'jpg', @setup.convert, cb
