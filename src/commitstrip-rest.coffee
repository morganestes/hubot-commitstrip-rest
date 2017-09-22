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
  robot.respond /commitstrip\s?(current|latest)?$/i, (res) ->
    wp.posts().perPage(1)
      .then (data) ->
        post = data[0]
        sendComic robot, res, post

      .catch (err) ->
        res.send "Encountered an error :( #{err}"

  # Gets a random comic.
  robot.respond /commitstrip random$/i, (res) ->
    # Find out how many posts there are, each on its own page.

    wp.posts()
      .then (data) ->
        totalPages = data._paging.totalPages
        pageNumber = Math.floor(Math.random() * totalPages) + 1

        # Get a single post from the collection of posts on the page
        wp.posts().page(pageNumber)
          .then (data) ->
            postsIndex = Math.floor(Math.random() * 10)

            post = data[postsIndex]
            sendComic robot, res, post

          .catch (err) ->
            console.log Object(err)
            res.send "Encountered an error :( #{err}"


      .catch (err) ->
        console.log Object(err)
        res.send "Encountered an error :( #{err}"
