chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
sinon = require 'sinon'
rewire = require 'rewire'
should = require('chai').should()

describe 'CmdEventHandler', ->
  CmdEventHandler = rewire '../lib/yadt-cmd-event-handler'
  event =
    id: 'cmd'
    cmd: 'update'
    target: 'target'
    state: 'failed'

  beforeEach ->
    @robot =
      send: sinon.spy()
    @roomSelector =
      getRooms: sinon.stub()
    @roomSelector.getRooms.returns([])
    constructor = sinon.stub().returns(@roomSelector)
    CmdEventHandler.__set__({'RoomSelector': constructor })
    @cmdEventHandler = new CmdEventHandler(@robot)

  describe 'handleEvent()', ->
    describe 'event =="cmd"', ->
      it 'calls room selector using the target from event', ->
        @cmdEventHandler.handleEvent(event)
        @roomSelector.getRooms.should.have.been.calledWith('target')

      describe 'and event.state != "failed"', ->
        statusEvent =
          id: 'id'

        beforeEach ->
          @roomSelector.getRooms.returns(['1'])

        it 'sends no message if state == "start"', ->
          statusEvent.state = 'start'
          @cmdEventHandler.handleEvent(statusEvent)

          @robot.send.should.not.have.been.called

        it 'sends no message if state == "finished"', ->
          statusEvent.state = 'finished'
          @cmdEventHandler.handleEvent(statusEvent)

          @robot.send.should.not.have.been.called

      describe 'and event.state == "failed"', ->
        whiteListedEvent =
          id: 'cmd'
          cmd: 'update'
          state: 'failed'
          target: 'target'

        beforeEach ->
          @roomSelector.getRooms.returns(['1'])

        it 'handles event "status"', ->
          whiteListedEvent.cmd = 'status'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.called

        it 'handles event "update"', ->
          whiteListedEvent.cmd = 'update'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.calledOnce

        it 'handles event "start"', ->
          whiteListedEvent.cmd = 'start'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.calledOnce

        it 'handles event "stop"', ->
          whiteListedEvent.cmd = 'stop'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.calledOnce

        it 'handles event "yadtshell update"', ->
          whiteListedEvent.cmd = '/usr/bin/python /usr/bin/yadtshell update'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.calledOnce

        it 'handles event "yadtshell start"', ->
          whiteListedEvent.cmd = '/usr/bin/python /usr/bin/yadtshell start'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.calledOnce

        it 'handles event "yadtshell stop"', ->
          whiteListedEvent.cmd = '/usr/bin/python /usr/bin/yadtshell stop'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.calledOnce

        describe 'and rooms from rooms selector', ->
          beforeEach ->
            @roomSelector.getRooms.returns(['1', '2'])
            whiteListedEvent.cmd = 'update'
            @cmdEventHandler.handleEvent(whiteListedEvent)

          it 'calls robot to send a message', ->
            @robot.send.should.have.been.calledTwice

          it 'creates a message containing the event details', ->
            call = @robot.send.getCall(0)
            should.exist(call, 'send should be called')
            should.exist(call.args[1], 'send should be called with message param')
            call.args[1].should.match(/update.*target.*failed/)

          it 'creates an envelop for the message', ->
            call = @robot.send.getCall(0)
            should.exist(call, 'send should be called')
            should.exist(call.args[0], 'send should be called with envelope param')
            call.args[0].should.be.eql({room: '1'})

      describe 'and no rooms from selector', ->
        beforeEach ->
          @roomSelector.getRooms.returns([])
          @cmdEventHandler.handleEvent(event)

        it 'does not send the message', ->
          @robot.send.should.not.have.been.called
