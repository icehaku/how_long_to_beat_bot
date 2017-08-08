require 'telegram/bot'
require 'net/http'
require 'uri'

class TelegramController < ApplicationController
	include Metacritic
	include Bot
	include InlineBot

  skip_before_action :verify_authenticity_token

  def callback
    #observer(params) 
    inline(params)

    render body: nil, head: :ok
  end

  def hi
  end
end
