module Bot
  extend ActiveSupport::Concern

  def observer(params)
    ttoken = '' #MCS-Bot
    token = '' #Ice Debug Bot

    if params["message"].present?
    	chat_id = params["message"]["chat"]["id"]
    	msg = params["message"]["text"]
    	games = metacritic(msg)
    end

    if games.present?
    	bot = Telegram::Bot::Client.new(token)

	    games.each do |game|
	    	game = game.dup
	    	begin
		    	if game['erro'] == "erro"
		    		text = game['erro_msg']
		    		bot.send_message chat_id: chat_id, text: text
		    	else
			    	text = "\xF0\x9F\x91\xBE <b>#{game['game_name']}</b>\n<b>Console</b>:#{game['console']}\n<b>Metascore</b>: #{game['metascore']}\n<b>Userscore</b>: #{game['userscore']}"
			    	bot.send_message chat_id: chat_id, text: text, parse_mode: "HTML"
			    	bot.send_photo chat_id: chat_id, photo: game['image']
			    	#emojis = http://apps.timwhitlock.info/emoji/tables/unicode
			    end
			  rescue
			  	return
			  end
	    end
	  end
  end

end
