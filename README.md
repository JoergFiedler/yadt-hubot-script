# Hubot: yadt-hubot-script
[![Build Status](https://travis-ci.org/JoergFiedler/yadt-hubot-script.png?branch=master)](https://travis-ci.org/JoergFiedler/yadt-hubot-script)

A hubot script that does the things

See [`src/yadt-hubot.coffee`](src/yadt-hubot.coffee) for full documentation.

## Installation

Add **yadt-hubot-script** to your `package.json` file:

```json
"dependencies": {
  "hubot": ">= 2.5.1",
  "yadt-hubot-script": ">= 0.0.0",
}
```

Add **yadt-hubot-script** to your `external-scripts.json`:

```json
["yadt-hubot-script"]
```

Run `npm install`

## Sample Interaction

```
hubot>> Deployment of 'yadt-target/machine' started.
hubot>> Deployment of 'yadt-target/machine' completed successful after 125 seconds.
```
