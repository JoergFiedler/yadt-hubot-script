chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.should

RoomSelector = require '../src/room-selector'
utils = require '../src/utils'

describe 'RoomSelector', ->

  beforeEach ->
    @loadConfigFile = sinon.stub(utils, 'loadConfigFile')
    config = require './room-selector-tests-config.coffee'
    @loadConfigFile.returns(config)
    @roomSelector = new RoomSelector()

  afterEach ->
    @loadConfigFile.restore()

  it 'returns dev room for dev targets', ->
    @roomSelector.createEnvelope('dev-machines').should.be.equal('#dev-room')

  it 'returns empty room for matched targets without room definition', ->
    @roomSelector.createEnvelope('skipped').should.be.equal('')

  it 'returns default room for all other targets', ->
    @roomSelector.createEnvelope('any-other').should.be.equal('#default-room')
