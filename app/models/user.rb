class User < ApplicationRecord
	validates_uniqueness_of :telegram_id
end
