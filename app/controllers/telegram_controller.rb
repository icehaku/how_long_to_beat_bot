require 'telegram/bot'
require 'net/http'
require 'uri'

class TelegramController < ApplicationController
	include Metacritic
	include Bot
	include InlineBot

  skip_before_action :verify_authenticity_token

  def callback
    #observer(params)
    inline(params)

    render body: nil, head: :ok
  end

  def hi
		#url = URI.encode("https://howlongtobeat.com/search_main.php")
		#url = URI.encode("http://www.metacritic.com")
		url = URI.encode("http://www.metacritic.com/search/all/pokemon/results")
		#raise url.inspect
		#url = "www.metacritic.com"

		#queryString:pokemo
		#t:games
		#sorthead:popular
		#sortd:Normal Order
		#plat:
		#length_type:main

		user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
		results = Nokogiri::HTML(open(url, 'User-Agent' => user_agent), nil, "UTF-8")

		raise results.inspect
  end
end
