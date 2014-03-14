class ChannelSelector

  constructor: ->
    @devPattern = /^dev.*/i
    @tuvPattern = /^tuv.*/i
    @proPattern = /^(ber|ham).*/i

  createEnvelope: (target) ->
    if @devPattern.test target
      room = '#it-dev-events'
    else if @tuvPattern.test target
      room = '#it-tuv-events'
    else if @proPattern.test target
      room = '#it-pro-events'

    if room
      envelope =
        room: room

    return envelope

module.exports = ChannelSelector
