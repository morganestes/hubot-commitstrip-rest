# Description:
#   Displays the most recent comic from the Commit Strip website.
#
# Dependencies:
# "cheerio": "^1.0.0-rc.2"
# "wpapi": "^1.1.2"
#
# Configuration:
#   None
#
# Commands:
#   hubot commitstrip (current) - gets the URL of the most recent Commit Strip
#   hubot commitstrip random - gets the URL of a random Commit Strip comic
#
# Author:
#   morganestes

cheerio = require('cheerio')
WPAPI = require('wpapi')

sendComic = (robot, res, post) ->

  if post is 'undefined'
    res.send 'no comic found'
    return

  # Load the post content and scrape the image source.
  $ = cheerio.load(post.content.rendered)
  image = $('img').attr('src')

  if image != '' then res.send image

  room = res.envelope.user.name
  robot.messageRoom room, post.title.rendered

module.exports = (robot) ->
  wp = new WPAPI {endpoint: 'http://www.commitstrip.com/en/wp-json'}

  # Gets the current comic.
  robot.respond /commitstrip( current)?$/i, (res) ->
    wp.posts().perPage(1)
      .then (data) ->
        post = data[0]
        sendComic robot, res, post

      .catch (err) ->
        res.send "Encountered an error :( #{err}"

  # Gets a random comic.
  robot.respond /commitstrip random$/i, (res) ->
    robot.http("#{baseUrl}/posts")
      .header('Accept', 'application/json')
      .get() (err, response, body) ->
        if err
          res.send "Encountered an error :( #{err}"
          return

        totalPosts = parseInt( response.headers['X-WP-Total'], 10)
        totalPages = parseInt( response.headers['X-WP-TotalPages'], 10)

        if totalPosts == 0 or response.statusCode isnt 200
          res.send 'no comics found'
          return
        else
          # Generate a random number from the number of pages to get a post.
          pageNumber = parseInt(Math.random(1, totalPages) * 100, 10)

          robot.http("#{baseUrl}/posts?page=#{pageNumber}")
            .header('Accept', 'application/json')
            .get() (err, response, body) ->
              if err
                res.send "Encountered an error :( #{err}"
                return

              # Generate a random number 0...9 to get a post.
              postNumber = parseInt(Math.random(0, 9) * 10, 10)
              sendComic robot, res, body, postNumber
