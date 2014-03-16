exports.channelConfig = [
  {
    regex: /dev.*/
    rooms: ['#dev-room', '#ops-rooms']
  },
  {
    regex: /skipped/
  },
  {
    regex: /.*/
    rooms: ['#devops-room']
  }
]
