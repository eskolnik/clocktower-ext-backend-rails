require "rails_helper"
# require "debug"

RSpec.describe "Grimoires", type: :request do
  fixtures :grimoires, :broadcasters, :game_sessions

  describe "GET /index" do
    it "Respons with JSON" do
      headers = { "ACCEPT" => "application/json" }
      get "/grimoires", :headers => headers

      expect(response.content_type).to eq("application/json; charset=utf-8")
      # binding.break
      json = JSON.parse(response.body)
      expect(json).to eq("{foo: 1}")
    end
  end

  xdescribe "GET /show" do
    # headers = {"ACCEPT" => "application/json"}
    # get /grimoires/, :params => { :channel_id => 1 }
  end
end
