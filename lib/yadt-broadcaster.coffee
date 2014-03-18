Log = require 'log'
wamp = require 'cupholder'
utils = require './utils'

class YadtBroadcaster
  constructor: (url, topics, handlers) ->
    @url = url
    @topics = topics or []
    @handlers = handlers or []

  setHandlers: (handlers) ->
    @handlers = handlers

  registerTargets: () ->
    for topic in @topics
      @client.subscribe topic

    utils.logger.debug 'Subscribed to topics:', @topics

  onEvent: (uri, event) ->
    for handler in @handlers
      handler.handleEvent(event)

  publish: (topic, event) ->
    console.log('topic:', topic, 'event: ', event)
    @client.publish(topic, event)

  disconnect: () ->
    for topic in @topics
      @client.unsubscribe topic
    @client.close()

  connect: ->
    utils.logger.debug 'Connect to: ', @url
    ybc = @
    @client = new wamp.Client @url
    @client.on "open", ->
      ybc.registerTargets()
    @client.on "event", (uri, event) ->
      ybc.onEvent(uri, event)
    @client.on "error", (e) ->
      logger.error 'Error while talking to yadt broadcaster:', e

module.exports = YadtBroadcaster
