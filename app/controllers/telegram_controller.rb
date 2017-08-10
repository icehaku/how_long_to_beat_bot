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
	end
end
