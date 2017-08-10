require 'telegram/bot'
require 'net/http'
require 'uri'

class TelegramController < ApplicationController
	include InlineBot

	skip_before_action :verify_authenticity_token

	def callback
	    inline(params)

	    render body: nil, head: :ok
	end

	def hi
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
			game_info = Hash.new()

			game_dom = game.css("div.search_list_image").css("a")

			game_info["name"] = game_dom.attribute("title").value
			game_info["image"] = game_dom.css("img").attribute("src").value
			game_info["url"] = game_dom.attribute("href").value

			game_dom = game.css("div.search_list_details_block")

			if game_dom.css("div.search_list_tidbit")[0].present?
				game_ready["categoria"] = game_dom.css("div.search_list_tidbit")[0].text
			end

			if game_dom.css("div.search_list_tidbit")[1].present?
				game_ready["categoria_tempo"] = game_dom.css("div.search_list_tidbit")[1].text
			end

			if game_dom.css("div.search_list_tidbit").present?
				games << game_ready
			end
		end
	end
end
