chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
sinon = require 'sinon'

describe 'YadtBroadcaster', ->
  wamp = require 'cupholder'
  YadtBroadcaster = require '../src/yadt-broadcaster'

  beforeEach ->
    @clientConstructorStub = sinon.stub(wamp, 'Client')
    @clientSpy =
      on: sinon.spy()
      subscribe: sinon.spy()
    @clientConstructorStub.returns(@clientSpy)

  afterEach ->
    @clientConstructorStub.restore()

  describe 'connect()', ->
    it 'creates a new wamp.Client with given URL', ->
      url = 'any-url'
      new YadtBroadcaster(url).connect()

      @clientConstructorStub.should.have.been.calledWith(url)

    it 'registers an listener on event "open"', ->
      new YadtBroadcaster('url').connect()
      @clientSpy.on.should.have.been.calledWith('open', sinon.match.instanceOf(Function))

    it 'registers an listener on event "event"', ->
      new YadtBroadcaster('url').connect()
      @clientSpy.on.should.have.been.calledWith('event', sinon.match.instanceOf(Function))

  describe 'on event', ->
    yadtBroadcaster = new YadtBroadcaster('url', ['topic1', 'topic2'])

    beforeEach ->
      yadtBroadcaster.connect()

    describe '"open"', ->
      beforeEach ->
        @openCallback = @clientSpy.on.getCall(0).args[1]

      it 'subscribes to all given topics', ->
        @openCallback(@clientSpy)

        @clientSpy.subscribe.should.have.been.calledTwice
        @clientSpy.subscribe.should.have.been.calledWith('topic1')
        @clientSpy.subscribe.should.have.been.calledWith('topic2')

    describe '"event"', ->
      beforeEach ->
        @handler1 =
          handleEvent: sinon.spy()
        @handler2 =
          handleEvent: sinon.spy()
        @event = sinon.mock()
        yadtBroadcaster.setHandlers([@handler1, @handler2])
        @eventCallback = @clientSpy.on.getCall(1).args[1]

      it 'calls all registered handlers', ->
        @eventCallback(undefined, @event)
        @handler1.handleEvent.should.have.been.calledWith(@event)
