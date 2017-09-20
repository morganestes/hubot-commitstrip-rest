# Description:
#   Displays the most recent comic from the Commit Strip website.
#
# Dependencies:
# "cheerio": "^1.0.0-rc.2"
#
# Configuration:
#   None
#
# Commands:
#   hubot commitstrip (current) - gets the URL of the most recent Commit Strip comic image
#
# Author:
#   morganestes

cheerio = require('cheerio')
url = 'https://www.commitstrip.com/en/wp-json/wp/v2'

module.exports = (robot) ->
  robot.respond /commitstrip( current)?$/i, (res) ->
    room = res.envelope.user.name
    today = new Date()

    robot.http("#{url}/posts?per_page=1")
      .header('Accept', 'application/json')
      .get() (err, response, body) ->
        throw err if err
        totalPosts = response.headers['x-wp-total']

        if parseInt(totalPosts, 10) == 0
          res.send 'no comic found'
          return

        #parse there response into JSON and get the first element
        posts = JSON.parse(body)
        post = posts[0]

        # load the post content and scrape the image source
        $ = cheerio.load(post.content.rendered)
        image = $('img').attr('src')

        if image != '' then res.send image
        return
