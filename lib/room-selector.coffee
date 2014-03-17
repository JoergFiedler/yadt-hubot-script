utils = require './utils'

class RoomSelector

  constructor: ->
    configFile = utils.loadConfigFile()
    @channelConfigs = configFile.channelConfig

  getRooms: (target) ->
    rooms = []
    for channelConfig in @channelConfigs
      if @matches(channelConfig.regex, target)
        rooms = channelConfig.rooms or []
        break

    return rooms

  matches: (regex, target) ->
    new RegExp(regex).test target

module.exports = RoomSelector
