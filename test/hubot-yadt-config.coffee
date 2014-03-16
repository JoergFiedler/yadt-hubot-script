exports.broadcasterUrl = 'ws://host:port'
exports.channelConfig = [
  {
    regex: "/^abc.*/i"
    rooms: ["#abc-channel"] },
  {
    regex: "/evil.*/i" },
  {
    regex: "/.*/"
    rooms: ['default'] }
]
exports.topics = ['dev-machines']
