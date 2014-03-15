# Hubot: yadt-hubot-script
[![Build Status](https://travis-ci.org/JoergFiedler/yadt-hubot-script.png?branch=master)](https://travis-ci.org/JoergFiedler/yadt-hubot-script)

Subscribes itself one or more topics provided by a [YaDT](http://www.yadt-project.org/) broadcaster and publishes those notifications. So far only `cmd` notification are supported.

See [`src/yadt-hubot-script.coffee`](src/yadt-hubot-script.coffee) for further documentation.

## Installation

Add **yadt-hubot-script** to your `package.json` file:

```json
"dependencies": {
  "hubot": ">= 2.5.1",
  "yadt-hubot-script": ">= 0.0.1",
}
```

Add **yadt-hubot-script** to your `external-scripts.json`:

```json
["yadt-hubot-script"]
```

Run `npm install`

## Sample Interaction

```
hubot>> Yadt action 'update' for target 'marvin.bot.net' has been 'started'.
hubot>> Yadt action 'update' for target 'marvin.bot.net' has been 'finished'.
```
