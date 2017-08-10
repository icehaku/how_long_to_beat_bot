module InlineBot
  extend ActiveSupport::Concern

	def inline(params)
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

      html_result = Nokogiri::HTML(party_response)
      html_result = html_result.css("li.back_white")
    rescue
      html_result = nil
    end

    if html_result.present?
      games = parse_scraped_games(html_result)

      token = '386847090:AAGmVhpUjbkmZKvqE8Wasx8PKRfBHh0domk' #How Long to Beat Bot
      bot = Telegram::Bot::Client.new(token)

      telegram_inline_result = create_telegram_inline_result(games)

      bot.answer_inline_query inline_query_id: inline_query_id, results: telegram_inline_result
    end
	end


  def parse_scraped_games(result)
    games = []

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

    return games
  end


  def create_telegram_inline_result(games)
    results = games.map.with_index do |game, index|
      {
        id: index.to_s,
        type: "article",
        title: game['name'],
        description: "#{game['categoria']}: #{game['categoria_tempo']}",
        thumb_url: "https://howlongtobeat.com/#{game['image']}",
        input_message_content: {
          parse_mode: "HTML",
          message_text: "\xF0\x9F\x91\xBE <b>#{game['name']}</b> \n <b>.#{game['categoria']}:</b> #{game['categoria_tempo']} \n https://howlongtobeat.com/#{game['url']}",
        },
      }
    end
  end

end
