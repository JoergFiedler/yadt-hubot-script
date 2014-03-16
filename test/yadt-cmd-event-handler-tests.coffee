chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
sinon = require 'sinon'
rewire = require 'rewire'

describe 'CmdEventHandler', ->
  CmdEventHandler = rewire '../lib/yadt-cmd-event-handler'
  event =
    id: 'cmd'
    cmd: 'status'
    target: 'target'
    state: 'state'

  beforeEach ->
    @robot =
      send: sinon.spy()
    @roomSelector =
      createEnvelope: sinon.stub()
    @roomSelector.createEnvelope.returns([])
    constructor = sinon.stub().returns(@roomSelector)
    CmdEventHandler.__set__({'RoomSelector': constructor })
    @cmdEventHandler = new CmdEventHandler(@robot)

  describe 'handleEvent()', ->
    describe 'event =="cmd"', ->
      it 'calls room selector using the target from event', ->
        @cmdEventHandler.handleEvent(event)
        @roomSelector.createEnvelope.should.have.been.calledWith('target')

      describe 'and rooms from rooms selector', ->
        beforeEach ->
          @roomSelector.createEnvelope.returns(['1', '2'])
          @cmdEventHandler.handleEvent(event)

        it 'calls robot to send a message', ->
          @robot.send.should.have.been.calledTwice

        it 'creates a message containing the event details', ->
          message = @robot.send.getCall(0).args[1]
          message.should.match(/status.*target.*state/)

        it 'creates an envelop for the message', ->
          message = @robot.send.getCall(0).args[0]
          message.should.be.eql({room: '1'})

      describe 'and no rooms from selector', ->

        beforeEach ->
          @roomSelector.createEnvelope.returns([])
          @cmdEventHandler.handleEvent(event)

        it 'does not send the message', ->
          @robot.send.should.not.have.been.called


