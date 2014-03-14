Log = require "log"
wamp = require "cupholder"

class YadtBroadcaster
  constructor: ->
    @logger = new Log process.env.HUBOT_LOG_LEVEL or 'info'
    @url = 'ws://yadtbroadcaster.rz.is24.loc:8081/'
    @ws_port = 8081
    @handlers = []
    @logger.debug('Constructor called.')

  setHandlers: (handlers) ->
    @handlers = handlers

  registerTargets: (client) ->
    topics = ['devi18n', 'devi18n02', 'tuvi18n', 'proi18n']
    for topic in topics
      client.subscribe topic

    @logger.debug 'Subscribed to topics:', topics

  onEvent: (uri, event) ->
    for handler in @handlers
      handler.handleEvent(event)

  connect: ->
    @logger.debug('Connect to: ', @url)
    ybc = @
    client = new wamp.Client @url
    client.on "open", ->
      ybc.registerTargets(client)
    client.on "event", (uri, event)->
      ybc.onEvent(uri, event)

module.exports = YadtBroadcaster
