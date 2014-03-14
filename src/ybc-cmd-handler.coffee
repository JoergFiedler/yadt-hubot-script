Log = require 'log'
ChannelSelector = require('./channel-selector')

class CmdEventHandler
  constructor: (robot, channelSelector) ->
    @robot = robot
    @channelSelector = channelSelector or new ChannelSelector()
    @logger = new Log process.env.HUBOT_LOG_LEVEL or 'info'

  createMessage: (event) ->
    "Yadt action '#{event.cmd}' for target '#{event.target}' has been '#{event.state}'."

  sendResponse: (event) ->
    envelope = @channelSelector.createEnvelope(event.target)
    if envelope
      @robot.send envelope, @createMessage(event)
    else
      @logger.warn "No channel for target '#{event.target}' found"

  handleEvent: (event) ->
    if event.id and event.id == 'cmd'
      @logger.debug 'Event received:', event.target, event.cmd, event.state
      @sendResponse(event)

module.exports = CmdEventHandler