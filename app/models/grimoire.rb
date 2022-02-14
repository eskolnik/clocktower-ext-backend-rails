require "faraday"
require "debug"

class Grimoire < ApplicationRecord
  belongs_to :game_session

  after_save :send_to_twitch

  # decode JSON or return empty JSON object if nil
  def parse(val, default = {})
    val.nil? ? default : JSON.parse(val)
  end

  # Call .to_json on this or hand it off to something that will do so
  def json_view
    {
      type: "grimoire",
      grimoire: {
        "player_id": player_id,
        "is_host": is_host,
        "players": parse(players),
        "bluffs": parse(bluffs, []),
        "edition": parse(edition),
        "roles": parse(roles),
      },
      isActive: self.game_session.is_active,
    }.deep_transform_keys { |k| k.to_s.camelize :lower }
  end

  # Attempt to send the grimoire to twitch
  def send_to_twitch
    twitch_pubsub_url = "https://api.twitch.tv/extensions/message"

    broadcaster = self.game_session.broadcaster

    token = broadcaster.json_web_token
    channel_id = broadcaster.channel_id

    # twitch_url = "#{twitch_pubsub_url}"

    message = self.json_view

    body = {
      content_type: "application/json",
      message: { test: "help pls" }.to_json,
      targets: ["broadcast"],
    }


    conn = Faraday.new(
      url: twitch_pubsub_url,
      params: {},
      headers: {
        "Content-Type" => "application/json",
        "Client-Id" => Rails.application.credentials.twitch[:client_id],
        "Authorization" => "Bearer " + token,
      },
    )

    postreq = conn.post(channel_id.to_s) do |request|
      request.body = body.to_json
    end

    binding.break
    puts postreq
  end
end
