exports.broadcasterUrl = 'ws://host:port'
exports.channelConfig = [
  {
    regex: "/^abc.*/i"
    room: "#abc-channel" },
  {
    regex: "/evil.*/i" },
  {
    regex: "/.*/"
    room: 'default' }
]
exports.topics = ['dev-machines']
