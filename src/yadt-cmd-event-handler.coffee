Log = require 'log'
RoomSelector = require './room-selector'
utils = require './utils'

class CmdEventHandler
  constructor: (robot) ->
    @robot = robot
    @roomSelector = new RoomSelector()

  createMessage: (event) ->
    "Yadt action '#{event.cmd}' for target '#{event.target}' has been '#{event.state}'."

  sendResponse: (event) ->
    room = @roomSelector.createEnvelope(event.target)
    if room
      @robot.send {'room': room}, @createMessage(event)
    else
      @logger.warn "No room for target '#{event.target}' configured."

  handleEvent: (event) ->
    if event.id and event.id == 'cmd'
      utils.logger.debug 'Event received:', event.target, event.cmd, event.state
      @sendResponse(event)

module.exports = CmdEventHandler