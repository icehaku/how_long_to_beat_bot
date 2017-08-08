module Metacritic
  extend ActiveSupport::Concern

	def metacritic(msg)
		command = check_commands(msg)
		if command
			case command
			when "/mcs"
			  metacritic_score_search(msg)
			when "/help"
			  bot_help
			when "/consoles"
			  consoles_list
			else
				""
			end
		end
	end


	def metacritic_score_search(msg)
		if check_plataform(msg)
			metacritic_single_url(msg)
		else
			game = msg.split(" ")[1..-1].join("-").downcase
			google_metacritic_search(game)
		end
	end


	def metacritic_single_url(msg)
		full_message = msg
		msg = msg.split(" ")
		base_url = "http://www.metacritic.com/game/"
		plataform = normalize_plataform(msg[1])
		game = full_message.split(" ")[2..-1].join("-").downcase
		url = "#{base_url}#{plataform}/#{game}"

		metacritic_data = metacritic_url_valid?(url)
		if metacritic_data.present?
			get_data_from_metacritic_page(metacritic_data)
		else
			google_metacritic_search(game)
		end
	end		


	def metacritic_url_valid?(url)
		user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
		page = ""

		begin
			page = Nokogiri::HTML(open(url, 'User-Agent' => user_agent), nil, "UTF-8")
    rescue OpenURI::HTTPError => ex
      page = nil
    end

	  return page
	end


	def get_data_from_metacritic_page(page)
		game_object = Hash.new()

		begin
			game_object["metascore"] = page.css("span[itemprop='ratingValue']").text
			game_object["userscore"] = page.css("div.product_scores").css("div.metascore_w.user.large.game")[0].text
			game_object["game_name"] = page.css("div.content_head.product_content_head.game_content_head").css("h1.product_title").css("span[itemprop='name']").text
			game_object["game_name"] = fix_name(game_object["game_name"])
			game_object["console"] = page.css("span[itemprop='device']").text
			game_object["console"] = fix_name(game_object["console"])
			game_object["image"] = page.css("img.product_image.large_image")[0].values[1]

			game_object["erro"] = "ok"
		rescue
			game_object["erro"] = "erro"
			game_object["erro_msg"] = "Acho que source do metacritic mudou, não consegui pegar os dados. Me da mais uma chance vai ;_;"
		end

		[game_object]
	end


	def google_metacritic_search(game)
		games = []
		google_search_api_key = "AIzaSyB7Zw7yzjKjGKC_AcnmpqC_QA8cC_l0mvc" 
		custom_search_code = "010005874503195795540:k0fg9etgjoa"
		html = "https://www.googleapis.com/customsearch/v1?key=AIzaSyB7Zw7yzjKjGKC_AcnmpqC_QA8cC_l0mvc&cx=010005874503195795540:k0fg9etgjoa&q=#{game}"

		begin
			items = JSON.load(open(html))
    rescue OpenURI::HTTPError => ex
      items = nil
    end

    if items.present?
			items = items["items"]
			items = items.delete_if {|item| item["pagemap"]["metatags"][0]["og:type"] != "game"}

			items.each do |item|
				url = item["pagemap"]["metatags"][0]["og:url"]
				page = metacritic_url_valid?(url)
				games << get_data_from_metacritic_page(page)
			end
		else
			game_object = Hash.new()

			game_object["erro"] = "erro"
			game_object["erro_msg"] = "A API do GoogleSearch que utilizo, esgotou a quantidade maxima permitida para pobres ;_; (é uma API paga)\nMas eu só preciso desse recurso quando a busca não é exata.\nSe voce buscar pelo nome certinho eu ainda consigo achar!"
			
			games << game_object
		end

		games
	end
end