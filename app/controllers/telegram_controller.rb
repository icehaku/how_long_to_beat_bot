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
		#require 'no_proxy_fix'

		url = URI.encode("https://howlongtobeat.com/search_main.php?page=1")
		party_response = HTTParty.post(url,
			body: {
				queryString:"pokemon",
				t:"games",
				sorthead:"popular",
				sortd:"Normal Order",
				length_type:"main",
			})

		result = Nokogiri::HTML(party_response)
		result = result.css("li.back_white")

		games = []
		result.each do |game|
			game_ready = Hash.new()

			game_ready["name"] = game.css("div.search_list_image").css("a").attribute("title").value
			game_ready["image"] = game.css("div.search_list_image").css("a").css("img").attribute("src").value
			game_ready["url"] = game.css("div.search_list_image").css("a").attribute("href").value

			if game.css("div.search_list_details_block").css("div.search_list_tidbit")[0].present?
				game_ready["categoria"] = game.css("div.search_list_details_block").css("div.search_list_tidbit")[0].text
			end

			if game.css("div.search_list_details_block").css("div.search_list_tidbit")[1].present?
				game_ready["categoria_tempo"] = game.css("div.search_list_details_block").css("div.search_list_tidbit")[1].text
			end

			if game.css("div.search_list_details_block").css("div.search_list_tidbit").present?
				games << game_ready
			end
		end
	end
end
