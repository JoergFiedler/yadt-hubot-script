chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect
ChannelSelector = require('../src/channel-selector')

describe 'ChannelSelector', ->
  beforeEach ->
    @channelSelector = new ChannelSelector()

  it 'returns dev envelope for dev targets', ->
    expect(@channelSelector.createEnvelope('devitl01')).to.deep.equal({room: 'it-dev-events'})

  it 'returns tuv envelope for tuv targets', ->
    expect(@channelSelector.createEnvelope('tuvitl01')).to.deep.equal({room: 'it-tuv-events'})

  it 'returns pro envelope for ber targets', ->
    expect(@channelSelector.createEnvelope('beritl01')).to.deep.equal({room: 'it-pro-events'})

  it 'returns pro envelope for ham targets', ->
    expect(@channelSelector.createEnvelope('hamitl01')).to.deep.equal({room: 'it-pro-events'})

  it 'returns undefined for unknown targets', ->
    expect(@channelSelector.createEnvelope('septl01')).to.equal(undefined)

