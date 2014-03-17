logger = require('./utils').logger

class StatusCommand
  constructor: (@message) ->

  username: ->
    @message.message.user.name

  target: ->
    @message.match[1]

module.exports = StatusCommand