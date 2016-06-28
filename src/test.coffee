# Test webshot with mermaid
# ====================================================

webshot = require 'webshot'

options =
  siteType: 'file'
  streamType: 'png'
  creenSize:
    width: 800
    height: 600
  captureSelector: '#page'
  renderDelay: 100
  errorIfStatusIsNot200: true
  errorIfJSException: true
  onError: (err) -> console.log '----', err

#webshot 'http://google.de', 'src/mermaid.png', options, (err) ->
webshot 'src/mermaid.html', 'src/mermaid.png', options, (err) ->
  console.log 'done', err
