# hubot-commitstrip-rest

Displays a comic from the Commit Strip website, using the WordPress REST API.

See [`src/commitstrip-rest.coffee`](src/commitstrip-rest.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-commitstrip-rest --save`

Then add **hubot-commitstrip-rest** to your `external-scripts.json`:

```json
[
  "hubot-commitstrip-rest"
]
```

## Sample Interaction

```
user1>> hubot commitstrip latest
hubot>> Project Scope
https://www.commitstrip.com/wp-content/uploads/2017/09/Strip-Dans-la-scope-650-finalenglish.jpg
user1>> hubot commitstrip random
hubot>> The eternal question
https://www.commitstrip.com/wp-content/uploads/2016/12/Strip-CMS-650-finalenglish.jpg
```

## NPM Module

https://www.npmjs.com/package/hubot-commitstrip-rest
