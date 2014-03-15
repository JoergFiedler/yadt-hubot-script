Log = require 'log'
YadtBroadcaster = require './yadt-broadcaster'
CmdHandler = require './yadt-cmd-event-handler'

class YadtHubot
  constructor: (robot) ->
    @robot = robot
    @logger = new Log process.env.HUBOT_LOG_LEVEL or 'info'
    @configFile = process.env.HUBOT_YADT_CONFIG

  loadConfigFile: ->
    try
      @config = require(@configFile)
      return @config
    catch error
      @logger.error("Can not load config file #{@configFile}.", error)

  createHandler: ->
    [
      new CmdHandler(@robot)
    ]

  initYadtBroadcaster: ->
    @logger.info("Using yadt broadcaster url: #{@config.broadcasterUrl}")
    @logger.info("Topics to su: #{@config.topics.length}")

    ybc = new YadtBroadcaster(@config.broadcasterUrl, @config.topics)
    ybc.setHandlers(@createHandler())
    ybc.connect()

  start: ->
    if not @loadConfigFile() == undefined
      @initYadtBroadcaster()

module.exports = YadtHubot
