# Description
#   Subscribes itself one or more topics provided by a YaDT broadcaster and
#   publishes those notifications. So far only `cmd` notification are supported.
#
# Dependencies
#   "log": "1.4.0",
#   "cupholder": "0.1.0-alpha"
#
# Configuration:
#   HUBOT_YADT_CONFIG
#
# Commands:
#   None.
#
# Notes:
#   You need a running Yadt broadcaster instance. The script will connect
#   to it and provide you with notifications about events on topics you
#   subscribed.
#
#   Sample configuration file which must be provided (HUBOT_YADT_CONFIG).
#
#      exports.broadcasterUrl = 'ws://host:port'
#      exports.channelConfig = [
#        {
#          regex: "/^abc.*/i"
#          room: "#abc-channel" },
#        {
#          regex: "/evil.*/i" },
#        {
#          regex: "/.*/"
#          room: 'default'
#        }
#      ]
#      exports.topics = ['dev-machines']
#
# Author:
#   JoergFiedler[@immobilienscout24.de]

HubotYadt = require './hubot-yadt'

module.exports = (robot) ->
  new HubotYadt(robot).start()
