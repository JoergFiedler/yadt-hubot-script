Log = require 'log'
RoomSelector = require './room-selector'
logger = require('./utils').logger

class CmdEventHandler

  constructor: (robot) ->
    @robot = robot
    @roomSelector = new RoomSelector()

  createMessage: (event) ->
    "Yadt action '#{event.cmd}' for target '#{event.target}' has been '#{event.state}'."

  sendResponse: (event) ->
    rooms = @roomSelector.createEnvelope(event.target)
    for room in rooms
      @robot.send {'room': room}, @createMessage(event)
    if not rooms
      logger.warning "No room for target '#{event.target}' configured."

  handleEvent: (event) ->
    if event.id and event.id == 'cmd'
      logger.debug 'Event received:', event.target, event.cmd, event.state
      @sendResponse(event)

module.exports = CmdEventHandler