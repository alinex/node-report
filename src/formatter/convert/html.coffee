# Convert HTML
# =================================================

webshot = null # load on demand

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
#--ssl-protocol=tlsv1', '--ignore-ssl-errors=true'

# Transformer rules
#
# @type {Object<Transformer>} rules to set output text in token
module.exports =

  png: (content, cb) -> screenshot content, 'png', @setup.convert, cb
  jpg: (content, cb) -> screenshot content, 'jpg', @setup.convert, cb

  pdf: (content, cb) ->
    webshot ?= require 'webshot'
    webshot content,
#      siteType: 'html'
      paperSize:
#        width: @setup.convert.width ? '612px'
#        height: @setup.convert.width ? '792px'
        orientation: 'portrait'
        format: 'A4'
#        border: '1cm'
      captureSelector: @setup.convert.capture ? '#page'
      renderDelay: 100
      settings:
        localToRemoteUrlAccessEnabled: true
        webSecurityEnabled: false
    , (err, stream) ->
      console.log '--------'
      return cb err if err
      buffer = ''
      stream.on 'data', (data) -> buffer += data.toString 'binary'
      stream.on 'end', -> cb null, buffer
