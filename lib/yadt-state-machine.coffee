StateMachine = require 'javascript-state-machine'

module.exports.create = ->
  StateMachine.create({
    'initial': 'idle'
    'error': (eventName, from, to, args, errorCode, errorMessage) ->
      console.log 'event ' + eventName + ' was naughty :- ' + errorMessage
    'events': [
      {'name': 'finished', 'from': 'idle', 'to': 'success'}
      {'name': 'waiting_timeout', 'from': 'idle', 'to': 'failure'}
      {'name': 'request', 'from': 'idle', 'to': 'waiting'}
      {'name': 'waiting_timeout', 'from': 'waiting', 'to': 'failure'}
      {'name': 'waiting_timeout', 'from': 'pending', 'to': 'pending'}
      {'name': 'failed', 'from': 'waiting', 'to': 'waiting'}
      {'name': 'started', 'from': 'waiting', 'to': 'pending'}
      {'name': 'pending_timeout', 'from': 'pending', 'to': 'failure'}
      {'name': 'failed', 'from': 'pending', 'to': 'failure'}
      {'name': 'failed', 'from': 'failure', 'to': 'failure'}
      {'name': 'finished', 'from': 'pending', 'to': 'success'}
      {'name': 'started', 'from': 'pending', 'to': 'pending'}
      {'name': 'waiting_timeout', 'from': 'failure', 'to': 'failure'}
      {'name': 'request', 'from': 'failure', 'to': 'failure'}
    ]
  })
