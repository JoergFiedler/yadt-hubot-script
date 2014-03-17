chai = require 'chai'
chai.should()
chai.use require 'sinon-chai'
rewire = require 'rewire'
sinon = require 'sinon'

describe 'StatusCommand', ->
  StatusCommand = require '../lib/yadt-status-command'

  beforeEach ->
    @message =
      match: ['yadt status target', 'target']
      message:
        user:
          name: 'username'

    @statusCommand = new StatusCommand(@message)

  it 'reads the user name from message', ->
    @statusCommand.username().should.be.eq('username')

  it 'reads the target from message', ->
    @statusCommand.target().should.be.eq('target')
