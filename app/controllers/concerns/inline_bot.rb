module InlineBot
  extend ActiveSupport::Concern

	def inline(params)
		query = ""
 		inline_query_id = ""

    if params["inline_query"].present?
    	inline_query_id = params["inline_query"]["id"]
    	query = params["inline_query"]["query"]
    end

    begin
      url = URI.encode("https://howlongtobeat.com/search_main.php?page=1")
      party_response = HTTParty.post(url,
        body: {
          queryString: query,
          t: "games",
          sorthead: "popular",
          sortd: "Normal Order",
          length_type: "main",
        })

      result = Nokogiri::HTML(party_response)
      result = result.css("li.back_white")
    rescue
      result = nil
    end

    games = []
    if result.present?
      result.each do |game|
        game_info = Hash.new()

        game_dom = game.css("div.search_list_image").css("a")

        game_info["name"] = game_dom.attribute("title").value
        game_info["image"] = game_dom.css("img").attribute("src").value
        game_info["url"] = game_dom.attribute("href").value

        game_dom = game.css("div.search_list_details_block")

        if game_dom.css("div.search_list_tidbit")[0].present?
          game_info["categoria"] = game_dom.css("div.search_list_tidbit")[0].text
        end

        if game_dom.css("div.search_list_tidbit")[1].present?
          game_info["categoria_tempo"] = game_dom.css("div.search_list_tidbit")[1].text
        end

        if game_dom.css("div.search_list_tidbit").present?
          games << game_info
        end
      end

      token = '386847090:AAGmVhpUjbkmZKvqE8Wasx8PKRfBHh0domk' #How Long to Beat Bot
      bot = Telegram::Bot::Client.new(token)

      results = games.map.with_index do |game, index|
        {
          id: index.to_s,
          type: "article",
          title: game['name'],
          description: "<b>#{game['name']}</b> \n #{game['categoria']}: #{game['categoria_tempo']}",
          thumb_url: "https://howlongtobeat.com/#{game['image']}",
          input_message_content: {
            parse_mode: "HTML",
            message_text: "\xF0\x9F\x91\xBE <b>#{game['name']}</b> \n <b>.#{game['categoria']}:</b> #{game['categoria_tempo']} \n https://howlongtobeat.com/#{game['url']}",
          },
        }
      end

      bot.answer_inline_query inline_query_id: inline_query_id ,results: results
    end
	end

end
