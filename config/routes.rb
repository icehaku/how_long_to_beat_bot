Rails.application.routes.draw do
	root to: 'telegram#hi'

	#post '/webhooks/telegram_XY9wMhL0M9Y0B2DBt0H22HFd01969KaB', to: 'telegram#callback'
	#get '/webhooks/telegram_XY9wMhL0M9Y0B2DBt0H22HFd01969KaB', to: 'telegram#callback'
	#get '/metacritic_inline', to: 'telegram#metacritic_inline'
	get '/hi', to: 'telegram#hi'
end
