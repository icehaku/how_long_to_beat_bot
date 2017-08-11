require "rails_helper"

RSpec.describe TelegramController, :type => :controller do
  describe "GET #hi" do
    it "responds successfully with an HTTP 200 status code" do
      get :hi

      expect(response).to be_success
    end
  end
end
