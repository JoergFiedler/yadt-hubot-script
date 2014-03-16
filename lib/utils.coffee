Log = require 'log'
logger = new Log process.env.HUBOT_LOG_LEVEL or 'info'

loadConfigFile = ->
  configFile = process.env.HUBOT_YADT_CONFIG
  try
    config = require(configFile)
    return config
  catch error
    logger.error("Can not load config file #{@configFile}.", error)

exports.loadConfigFile = loadConfigFile
exports.logger = logger
