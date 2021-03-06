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
#   Sample configuration file which must be provided. Export the file name
#   via HUBOT_YADT_CONFIG environment variable.
#
#      exports.broadcasterUrl = 'ws://host:port'
#      exports.channelConfig = [
#        {
#          regex: /^dev.*/i
#          rooms: ["#dev-channel", "#ops-channel"] },
#        {
#          regex: /evil.*/i },
#        {
#          regex: /.*/
#          rooms: ["#devops-channel"]
#        }
#      ]
#      exports.topics = ['dev-machines']
#
# Author:
#   JoergFiedler[@immobilienscout24.de]

HubotYadt = require '../lib/hubot-yadt'

module.exports = (robot) ->
  new HubotYadt(robot).start()
