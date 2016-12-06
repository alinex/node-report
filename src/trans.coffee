# Translations
# =================================================
# This package exports a method to access the translations and contains the current
# translation index.




# Translation
# -------------------------------------------------

exports.data =
  content:
    en: 'Content'
    de: 'Inhalt'
  index:
    en: 'Index'
  lang:
    coffeescript:
      en: 'CoffeeScript'
    iced:
      en: 'IcedCoffeeScript'
    javascript:
      en: 'JavaScript'
    ruby:
      en: 'Ruby Code'
    python:
      en: 'Python Code'
    perl:
      en: 'Perl Script'
    cpp:
      en: 'C++ Code'
    cc:
      en: 'C Code'
    cs:
      en: 'C# Code'
    java:
      en: 'Java Code'
    jsp:
      en: 'Java Server Pages'
    groovy:
      en: 'Groovy Code'
    php:
      en: 'PHP Code'
    bash:
      en: 'Shell Script'
    makefile:
      en: 'Makefile'
    sql:
      en: 'SQL Code'
    handlebars:
      en: 'Handlebars Template'
    jade:
      en: 'Jade Template'
    css:
      en: 'Cascading Stylesheet'
    stylus:
      en: 'Stylus Stylesheets'
    scss:
      en: 'Sassy CSS'
    less:
      en: 'Less Stylesheets'
    cson:
      en: 'CSON Data'
    json:
      en: 'JSON Data'
    yaml:
      en: 'YAML Data'
    markdown:
      en: 'Markdown Document'
    html:
      en: 'HTML Document'
  boxes:
    detail:
      en: 'Details'
    info:
      en: 'Info'
    warning:
      en: 'Warning'
      de: 'Warnung'
    alert:
      en: 'Attention'
      de: 'Achtung'
  tabs:
    max:
      en: 'Maximize box to show full content'
      de: 'Box mavimieren und kompletten Inhalt zeigen'
    scroll:
      en: 'Show in default view with possible scroll bars'
      de: 'Anzeigen in standard Größe (mit Scrolleiste wenn nötig)'
    min:
      en: 'Close box content'
      de: 'Box schließen'
    switch:
      en: 'Switch tab'
      de: 'Karte wechseln'


# Access Method
# -------------------------------------------------

# @param {String} tag the name of the translation entry
# @param {String} locale to specify the language to get if available (fallback is english)
# @param {Object} [trans] the translation memory in which to search (used internally only)
# @return {String} the translation entry
exports.get = (tag, locale, tr = exports.data) ->
  parts = tag.split /\./
  return exports.get parts[1..].join('.'), locale, tr[parts[0]] unless parts.length is 1
  tr[tag]?[locale] ? tr[tag]?[locale[0..1]] ? tr[tag]?.en ? tag
