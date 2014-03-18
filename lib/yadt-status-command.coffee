logger = require('./utils').logger
loadConfigFile = utils = require('./utils').loadConfigFile
YadtBroadcaster = require './yadt-broadcaster'
uuid = require 'node-uuid'
yadtStates = require './yadt-state-machine'


class StatusCommand
  constructor: (@message) ->
    @id = uuid.v4()
    @yadt = yadtStates.create()

  username: ->
    @message.message.user.name

  target: ->
    @message.match[1]

  execute: ->
    config = loadConfigFile()
    if config
      @yadtBroadcaster = new YadtBroadcaster(config.broadcasterUrl,
        [@target()],
        [@])
      @yadtBroadcaster.connect()

  createStatusCommand: () ->
    cmd =
      'id': 'request'
      'type': 'event'
      'cmd': 'yadt'
      'args': ['status', "--tracking-id=#{@id}"]
      'tracking_id': null
      'target': @target()
      'payload': null
    cmd

  isInitEvent: (event) ->
    'full-update' == event.id and event.tracking_id != @id

  isStatusReceivedEvent: (event) ->
    'full-update' == event.id and event.tracking_id != @id

  onWaiting: (event, from, to) ->
    console.log(event, from, to)

  onFailed: (event, from, to) ->
    console.log(event, from, to)
    @yadtBroadcaster.disconnect()

  onPending: (event, from, to) ->
    console.log(event, from, to)

  onFailure: (event, from, to) ->
    console.log(event, from, to)
    @yadtBroadcaster.disconnect()

  onWaitingTimeout: (event, from, to) ->
    console.log(event, from, to)

  onPendingTimeout: (event, from, to) ->
    console.log(event, from, to)

  onSuccess: (event, from, to) ->
    console.log('Yadt command "status" finished successfully.')
    @yadtBroadcaster.disconnect()

  bind: (scope, fn) ->
    ->
      fn.apply scope, arguments

  handleEvent: (event) ->
    event.payload = ''
    if @isInitEvent(event)
      @yadt.onwaiting = @bind @, @onWaiting
      @yadt.onfailed = @bind @, @onFailed
      @yadt.onpending = @bind @, @onPending
      @yadt.onsuccess = @bind @, @onSuccess
      @yadt.onfailure = @bind @, @onFailure
      @yadt.onwaiting_timeout = @bind @, @onWaitingTimeout
      @yadt.onpending_timeout = @bind @, @onPendingTimeout
      @yadt.request()
      @yadtBroadcaster.publish @target(), @createStatusCommand()
    else if event.tracking_id == @id and event.state
      @yadt[event.state].apply @yadt
    else
      console.log "I'm not going to do work which belongs to someone else. Go away!"

module.exports = StatusCommand
