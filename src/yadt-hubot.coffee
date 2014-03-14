# Description
#   A hubot script that does the things
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   JoergFiedler[@<org>]
YadtBroadcaster = require './yadt-broadcaster'
CmdHandler = require './ybc-cmd-handler'

url = process.env.YADT_BROADCASTER_URL
topicsFile = process.env.YADT_BROADCASTER_TOPICS

module.exports = (robot, yadtBroadcaster) ->
  if url == undefined or topicsFile == undefined
    console.warn("Configuration not valid. " +
                 "YADT_BROADCASTER_URL:'#{url}' YADT_BROADCASTER_TOPICS:'#{targets}'")
  else
    handlers = [
      new CmdHandler(robot)
    ]

    topics = require(topicsFile)

    ybc = yadtBroadcaster or new YadtBroadcaster(url, topics.topics)
    ybc.setHandlers(handlers)
    ybc.connect()
