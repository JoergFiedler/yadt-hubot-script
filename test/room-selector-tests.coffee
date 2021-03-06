chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'
expect = chai.should


describe 'RoomSelector', ->
  RoomSelector = require '../lib/room-selector'
  utils = require '../lib/utils'

  beforeEach ->
    @loadConfigFile = sinon.stub(utils, 'loadConfigFile')
    config = require './room-selector-tests-config.coffee'
    @loadConfigFile.returns(config)
    @roomSelector = new RoomSelector()

  afterEach ->
    @loadConfigFile.restore()

  it 'returns dev room for dev targets', ->
    @roomSelector.getRooms('dev-machines').should.be.deep.equal(['#dev-room', '#ops-rooms'])

  it 'returns empty room for matched targets without room definition', ->
    @roomSelector.getRooms('skipped').should.be.deep.equal([])

  it 'returns default room for all other targets', ->
    @roomSelector.getRooms('any-other').should.be.deep.equal(['#devops-room'])
