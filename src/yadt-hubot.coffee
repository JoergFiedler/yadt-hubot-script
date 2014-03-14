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

module.exports = (robot, yadtBroadcaster) ->
  handlers = [
    new CmdHandler(robot)
  ]

  ybc = yadtBroadcaster or new YadtBroadcaster()
  ybc.setHandlers(handlers)
  ybc.connect()
