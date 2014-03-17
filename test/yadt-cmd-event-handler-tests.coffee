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

      describe 'and event.state != "failed"', ->
        statusEvent =
          id: 'id'

        beforeEach ->
          @roomSelector.createEnvelope.returns(['1'])

        it 'sends no message if state == "start"', ->
          statusEvent.state = 'start'
          @cmdEventHandler.handleEvent(statusEvent)

          @robot.send.should.not.have.been.called

        it 'sends no message if state == "finished"', ->
          statusEvent.state = 'finished'
          @cmdEventHandler.handleEvent(statusEvent)

          @robot.send.should.not.have.been.called

      describe 'and event.cmd in whitelist', ->
        whiteListedEvent =
          id: 'cmd'
          state: 'failed'
          target: 'whitelisted'

        beforeEach ->
          @roomSelector.createEnvelope.returns(['1'])

        it 'handles event "status"', ->
          whiteListedEvent.cmd = 'status'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.not.have.been.called

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

        it 'handles event "yadtshell udpdate"', ->
          whiteListedEvent.cmd = '/usr/bin/python /usr/bin/yadtshell update'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.calledOnce

        it 'handles event "yadtshell start"', ->
          whiteListedEvent.cmd = '/usr/bin/python /usr/bin/yadtshell update'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.calledOnce

        it 'handles event "yadtshell stop"', ->
          whiteListedEvent.cmd = '/usr/bin/python /usr/bin/yadtshell update'
          @cmdEventHandler.handleEvent(whiteListedEvent)
          @robot.send.should.have.been.calledOnce

        describe 'and rooms from rooms selector and event.state != "failed"', ->
          it 'calls not robot if event.state !="failed"', ->
            event =
              id: 'id'
              cmd: 'update'
              state: 'start'
            @roomSelector.createEnvelope.returns(['1'])
            @cmdEventHandler.handleEvent(event)
            @robot.send.should.not.have.been.called

        describe 'and rooms from rooms selector', ->
          beforeEach ->
            @roomSelector.createEnvelope.returns(['1', '2'])
            @cmdEventHandler.handleEvent(whiteListedEvent)

          it 'calls robot to send a message', ->
            @robot.send.should.have.been.calledTwice

          it 'creates a message containing the event details', ->
            call = @robot.send.getCall(0)
            should.exist(call, 'send should be called')
            should.exist(call.args[1], 'send should be called with message param')
            call.args[1].should.match(/update.*whitelisted.*failed/)

          it 'creates an envelop for the message', ->
            call = @robot.send.getCall(0)
            should.exist(call, 'send should be called')
            should.exist(call.args[0], 'send should be called with envelope param')
            call.args[0].should.be.eql({room: '1'})

      describe 'and no rooms from selector', ->
        beforeEach ->
          @roomSelector.createEnvelope.returns([])
          @cmdEventHandler.handleEvent(event)

        it 'does not send the message', ->
          @robot.send.should.not.have.been.called
