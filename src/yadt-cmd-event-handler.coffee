Log = require 'log'
RoomSelector = require('./room-selector')

class CmdEventHandler
  constructor: (robot) ->
    @robot = robot
    @roomSelector = new RoomSelector()
    @logger = new Log process.env.HUBOT_LOG_LEVEL or 'info'

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
      @logger.debug 'Event received:', event.target, event.cmd, event.state
      @sendResponse(event)

module.exports = CmdEventHandler