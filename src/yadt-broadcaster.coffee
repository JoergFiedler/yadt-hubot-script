Log = require "log"
wamp = require "cupholder"

class YadtBroadcaster
  constructor: (url, topics) ->
    @logger = new Log process.env.HUBOT_LOG_LEVEL or 'info'
    @url = url
    @topics = topics or []
    @handlers = []

  setHandlers: (handlers) ->
    @handlers = handlers

  registerTargets: (client) ->
    for topic in @topics
      client.subscribe topic

    @logger.debug 'Subscribed to topics:', @topics

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
