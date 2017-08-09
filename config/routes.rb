Rails.application.routes.draw do
	root to: 'telegram#hi'

	post '/webhooks/telegram_HLTBMhL0M9Y0B2DBt0H22HFd01969ICE', to: 'telegram#callback'
	#get '/webhooks/telegram_XY9wMhL0M9Y0B2DBt0H22HFd01969KaB', to: 'telegram#callback'
	#get '/metacritic_inline', to: 'telegram#metacritic_inline'
	get '/hi', to: 'telegram#hi'
end

#https://how-long-beat-bot.herokuapp.com/webhooks/telegram_HLTBMhL0M9Y0B2DBt0H22HFd01969ICE
#https://api.telegram.org/bot386847090:AAGmVhpUjbkmZKvqE8Wasx8PKRfBHh0domk/setWebhook
