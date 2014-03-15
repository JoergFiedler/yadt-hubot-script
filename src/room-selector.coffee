utils = require './utils'

class RoomSelector

  constructor: ->
    configFile = utils.loadConfigFile()
    @channelConfigs = configFile.channelConfig

  createEnvelope: (target) ->
    room = ''
    for channelConfig in @channelConfigs
      if @matches(channelConfig.regex, target)
        room = channelConfig.room or ''
        break

    return room

  matches: (regex, target) ->
    new RegExp(regex).test target

module.exports = RoomSelector
