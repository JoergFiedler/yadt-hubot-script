exports.broadcasterUrl = 'ws://host:port'
exports.channelConfig = [
  {
    regex: "/^abc.*/i"
    channel: "#abc-channel" },
  {
    regex: "/evil.*/i" },
  {
    regex: "/.*/"
    channel: 'default' }
]
exports.topics = ['dev-machines']
