module InlineBot
  extend ActiveSupport::Concern

	def inline(params)
		query = ""
 		inline_query_id = ""

    if params["inline_query"].present?
    	inline_query_id = params["inline_query"]["id"]
    	query = params["inline_query"]["query"]
    end		
	
		url = URI.encode("http://www.metacritic.com/search/all/#{query}/results")
		user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"

		begin
			results = Nokogiri::HTML(open(url, 'User-Agent' => user_agent), nil, "UTF-8")
    rescue OpenURI::HTTPError => ex
    	results = nil
    end

    games = []
    if results.present?
    	results = results.css("li.result")

	    results.each do |result|
	    	if result.css("div.result_type").css("strong").text == "Game"
					game = Hash.new()
					game["name"] = result.css("a").text
					game["release"] = result.css("li.stat.release_date").css("span.data").text
					game["platform"] = result.css("span.platform").text
					game["metascore"] = result.css("span.metascore_w").text
					game["description"] = result.css("p.deck.basic_stat").text
					game["url"] = result.css("a")[0]['href']
					game["url"] = "http://www.metacritic.com#{game["url"]}"
          if game["metascore"].present?
            game["image"] = set_metascore_image(game["metascore"])
            game["metascore"] = "#{game['metascore']}"            
          else
            game["image"] = "http://www.headslinger.com/feed_img/1000565.jpg"
          end          
					#game["image_userscore"] = get_metacritic_image_userscore_by_url(game["url"])

					games << game
				end
	    end
	  end

    token = '350328660:AAGWpPvLjrHihatk_OhCioDWGHEyjYh2Pts' #Ice Debug Bot
    bot = Telegram::Bot::Client.new(token)

    results = games.map.with_index do |game, index|
      {
        type: "article",
        title: "#{game['name']}(#{game['platform']}) MS:#{game['metascore']}",
        id: index.to_s,
        description: game["description"],
        thumb_url: game["image"],
        input_message_content: {
          parse_mode: "HTML",
          message_text: "\xF0\x9F\x91\xBE <b>#{game['name']}</b>\n<b>Console</b>: #{game['platform']}\n<b>Metascore</b>: #{game['metascore']}\n<b>Release</b>: #{game['release']}\n#{game['description']}\n#{game['url']}",
        },
      }
    end

    bot.answer_inline_query inline_query_id: inline_query_id ,results: results
	end


  def get_metacritic_image_userscore_by_url(url)
    begin
      user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
      url = "http://www.metacritic.com#{url}"
      page = Nokogiri::HTML(open(url, 'User-Agent' => user_agent), nil, "UTF-8")
      image = page.css("img.product_image.large_image")[0].values[1]    
      userscore = page.css("div.product_scores").css("div.metascore_w.user.large.game")[0].text
      [image, userscore]
    rescue
      ["", ""]
    end
  end


  def set_metascore_image(score)
    grade = score.to_i

    if grade > 75
      "https://placeholdit.imgix.net/~text?txtsize=33&txt=#{score}&150&w=75&h=75&bg=33cc33&txtclr=ffffff"
    elsif grade > 45
      "https://placeholdit.imgix.net/~text?txtsize=33&txt=#{score}&150&w=75&h=75&bg=fed731&txtclr=ffffff"
    else
      "https://placeholdit.imgix.net/~text?txtsize=33&txt=#{score}&150&w=75&h=75&bg=cc0000&txtclr=ffffff"
    end
  end
end
