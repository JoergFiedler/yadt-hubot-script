chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect
RoomSelector = require('../src/room-selector')

describe 'RoomSelector', ->
  beforeEach ->
    @roomSelector = new RoomSelector()

  it 'returns dev envelope for dev targets', ->
    expect(@roomSelector.createEnvelope('devitl01')).to.deep.equal({room: '#it-dev-events'})

  it 'returns tuv envelope for tuv targets', ->
    expect(@roomSelector.createEnvelope('tuvitl01')).to.deep.equal({room: '#it-tuv-events'})

  it 'returns pro envelope for ber targets', ->
    expect(@roomSelector.createEnvelope('beritl01')).to.deep.equal({room: '#it-pro-events'})

  it 'returns pro envelope for ham targets', ->
    expect(@roomSelector.createEnvelope('hamitl01')).to.deep.equal({room: '#it-pro-events'})

  it 'returns undefined for unknown targets', ->
    expect(@roomSelector.createEnvelope('septl01')).to.equal(undefined)

