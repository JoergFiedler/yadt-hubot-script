Log = require 'log'
RoomSelector = require './room-selector'
logger = require('./utils').logger

class CmdEventHandler

  constructor: (robot) ->
    @robot = robot
    @roomSelector = new RoomSelector()

  createMessage: (event) ->
    command = event.cmd
    if /(.*yadtshell\s)?update/.test event.cmd # shorten message from yadt shell sources
      command = 'update'

    if 'failed' == event.state
      return "Yadt action '#{command}' for target '#{event.target}' has been '#{event.state}'."

  sendResponse: (event) ->
    rooms = @roomSelector.createEnvelope(event.target)
    for room in rooms
      message = @createMessage(event)
      @robot.send({'room': room}, message) if message
    if not rooms
      logger.warning "No room for target '#{event.target}' configured."

  handleEvent: (event) ->
    if event.id and event.id == 'cmd' and @matchesWhitelist(event.cmd)
      logger.debug 'Event received:', event
      @sendResponse(event)

  matchesWhitelist: (cmd) ->
    new RegExp(/(.*yadtshell\s)?(update|stop|start)/).test cmd

module.exports = CmdEventHandler