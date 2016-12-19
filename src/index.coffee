# Report generation
# =================================================
# This package will give you an easy and robust way to access mysql databases.


# Node Modules
# -------------------------------------------------
debug = require('debug') 'report'
chalk = require 'chalk'
deasync = require 'deasync'
# include more alinex modules
util = require 'alinex-util'
config = require 'alinex-config'
# modules
parser = require './parser/index'


# Setup
# -------------------------------------------------


# API
# -------------------------------------------------
class Report

  constructor: ->
    @source = []

  import: (text) ->


module.exports = Report
