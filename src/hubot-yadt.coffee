Log = require 'log'
YadtBroadcaster = require './yadt-broadcaster'
CmdEventHandler = require './yadt-cmd-event-handler'
utils = require './utils.coffee'

class HubotYadt
  constructor: (robot) ->
    @robot = robot
    @configFile = process.env.HUBOT_YADT_CONFIG

  createHandler: ->
    [
      new CmdEventHandler(@robot)
    ]

  initYadtBroadcaster: (config)->
    utils.logger.debug("Using yadt broadcaster url: #{config.broadcasterUrl}")
    utils.logger.debug("Topics:  #{config.topics.length}")

    ybc = new YadtBroadcaster(config.broadcasterUrl, config.topics)
    ybc.setHandlers(@createHandler())
    ybc.connect()

  start: ->
    config = utils.loadConfigFile()
    if not config == undefined
      @initYadtBroadcaster(config)

module.exports = HubotYadt
