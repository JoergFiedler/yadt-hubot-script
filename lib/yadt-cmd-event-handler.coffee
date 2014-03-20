Log = require 'log'
RoomSelector = require './room-selector'
logger = require('./utils').logger

# Listen to events with id 'cmd' and send messages
# for those events which failed to execute
class CmdEventHandler

  constructor: (robot) ->
    @robot = robot
    @roomSelector = new RoomSelector()

  createMessage: (event) ->
    command = event.cmd
    if /(.*yadtshell\s)?update/.test event.cmd # shorten message from yadt shell sources
      command = 'update'

    "Yadt action '#{command}' for target '#{event.target}' '#{event.state}'."

  sendResponse: (event) ->
    rooms = @roomSelector.getRooms(event.target)
    for room in rooms
      @robot.send {'room': room}, @createMessage(event)
    if not rooms
      logger.warning "No room for target '#{event.target}' configured."

  handleEvent: (event) ->
    logger.debug 'Event received:', event, event.payload
    if event.id and 'cmd' == event.id and 'failed' == event.state and !(/yadt/.test event.cmd)
      @sendResponse(event)

module.exports = CmdEventHandler
