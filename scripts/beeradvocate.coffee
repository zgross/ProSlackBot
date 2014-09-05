# Description:
#   An alternate to the existing beer script, this will scrape beer advocate for the most recent accessed beer.
#   It returns the name of the beer, a picture of the beer and a link to the beer. Hubot is now full of
#   different options for beer scripts. Removing the ? (optional) after (a|advocate) will force the command
#   to be 'beer advocate me' and thereby allow this script to coexist with other beer scripts peacefully.
#
# Dependencies:
#   "cheerio": "0.7.0"
#
# Configuration:
#   None
#
# Commands:
#   hubot advocate beer - returns the latest beer discussed on beer advocate with picture
#
# Author:
#   zgross

cheerio = require('cheerio')

module.exports = (robot) ->
  robot.respond /(a|advocate) beer?/i, (msg) ->
    url = "http://www.beeradvocate.com/beer/"
    msg.http(url)
       .header('User-Agent', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6')
       .get() (err, res, body) ->
          if (err)
            msg.send "There was an error contacting beeradvocate.com"
            return
          msg.send "#{getBeerName body}"
          msg.send "Brewed by: #{getBrewery body}" 
          msg.send "Style: #{getBeerStyle body}"
          msg.send "#{getBeerABV body}"
          msg.send "www.beeradvocate.com#{getBeerLink body}"

getBeerABV = (body, callback) ->
  $ = cheerio.load(body)
  $('div#rating_fullview_content_3').text().match(/\d+\.\d+/)[0] + " ABV"

getBeerName = (body, callback) ->
  $ = cheerio.load(body)
  $('div#rating_fullview_content_3 h6').text()

getBeerLink = (body, callback) ->
  $ = cheerio.load(body)
  $('div#rating_fullview_content_3 h6 a').attr('href')

getBeerStyle = (body, callback) ->
  $ = cheerio.load(body)
  $($('div#rating_fullview_content_3 a')[2]).text()

getBrewery = (body, callback) ->
  $ = cheerio.load(body)
  $($('div#rating_fullview_content_3 a')[1]).text()
