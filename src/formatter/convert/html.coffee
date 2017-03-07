# Convert HTML
# =================================================

webshot = null # load on demand
html2pdf = null # load on demand


screenshot = (content, type, setup, cb) ->
  webshot ?= require 'webshot'
  webshot content,
    siteType: 'html'
    streamType: type
    screenSize:
      width: setup.width ? 600
      height: setup.height ? 100
    captureSelector: setup.capture ? '#page'
    renderDelay: 100
    settings:
      localToRemoteUrlAccessEnabled: true
      webSecurityEnabled: false
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

  pdf: (content, cb) ->
    html2pdf ?= require 'html-pdf'
    conv = html2pdf.create "<html><body><h1>Hi</h1></body></html>",
      type: 'pdf'
      format: 'Letter'
      orientation: 'portrait'
      border: '1cm'
    conv.toBuffer cb
