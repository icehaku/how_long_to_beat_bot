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


	def check_commands(command)
		if command.present?
			command = command.split(" ")

			commands = [
				"/mcs",
				"/help",
				"/plataforms",
			]

			if commands.include?(command[0]) and command.length > 1
				command[0]
			else
				nil
			end
		else
			nil
		end
	end


	def check_plataform(plataform)
		plataform = plataform.split(" ")

		plataforms = [
			"ps1",
			"playstation", 
			"playstation", 
			"ps2",
			"playstation2", 
			"playstation-2", 
			"ps3",
			"playstation3",
			"playstation-3", 
			"ps4", 
			"playstation4",
			"playstation-4",
			"psp",
			"psvita",
			"ps-vita",								
			"n64",
			"nintendo64",			
			"nintendo-64",
			"gc",
			"gamecube",
			"game-cube",
			"wii",
			"nintendo-wii",
			"wiiu", 			
			"wii-u",
			"switch",			
			"nintendo-switch",
			"gba",
			"game-boy-advance",			 
			"ds",
			"nds",					
			"nintendo-ds",
			"3ds",
			"nintendo-3ds",
			"xbox",			
			"x360", 
			"xbox-360",
			"xbox1", 
			"xbox-one",
			"dreamcast",
			"pc",
		]

		if plataforms.include?(plataform[1])
			true
		else
			false
		end
	end


	def fix_name(name)
		name = name.gsub("\n","")
		name = name.gsub("  ","") 
	end


	def normalize_plataform(plataform)
			case plataform
			when "ps1", "playstation", "playstation"
			  "playstation"
			when "ps2", "playstation-2", "playstation2"
			  "playstation-2"
			when "ps3", "playstation-3", "playstation3"
			  "playstation-3"			  			  				
			when "ps4", "playstation-4", "playstation4"
			  "playstation-4"
			when "psp"
			  "psp"	 		
			when "pspvita", "psp-vita"
			  "playstation-vita"				  	  	  
			when "n64", "nintendo-64", "nintendo64"
			  "nintendo-64"
			when "gc", "game-cube", "gamecube"
			  "gamecube"			
			when "wii", "nintendo-wii"
			  "wii"			
			when "wiiu", "wii-u"
			  "wii-u"	
			when "switch", "nintendo-switch"
			  "switch"
			when "gba", "game-boy-advance"
			  "game-boy-advance"			  				  
			when "ds", "nds", "nintendo-ds"
			  "ds"	
			when "3ds", "nintendo-3ds"
			  "3ds"
			when "xbox"
			  "xbox"
			when "x360", "xbox-360"
			  "xbox-360"			
			when "xbox1", "xbox-one"
			  "xbox-one"
			when "dreamcast"
			  "dreamcast"			  
			when "pc"
			  "pc"			  			  		  					  				  			  			  	  	  		
			else
				"nope"
			end		
	end


	def bot_help
	end


	def bot_platatorms
	end			

end



