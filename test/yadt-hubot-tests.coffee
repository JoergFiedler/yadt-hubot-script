chai = require 'chai'
sinon = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'yadt-hubot script', ->
  beforeEach ->
    process.env.YADT_BROADCASTER_URL = 'any_url'
    process.env.YADT_BROADCASTER_TOPICS = '../test/yadt-topics'

    @robot = sinon.mock()
    @yadtBroadcaster =
      setHandlers: sinon.spy()
      connect: sinon.spy()

    require('../src/yadt-hubot')(@robot, @yadtBroadcaster)

  it 'adds a set of handler to yadt broadcaster', ->
    expect(@yadtBroadcaster.setHandlers.called).to.equal(true)

  it 'calls connect on yadt broadcaster', ->
    expect(@yadtBroadcaster.connect.called).to.equal(true)
