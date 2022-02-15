# the Ruby JWT library doesn't seem up to the task, so we're rolling our own.
require "json"
require "base64"
require "openssl"

class Broadcaster < ApplicationRecord
  has_one :game_session

  def json_view
    self.as_json.deep_transform_keys { |k| k.to_s.camelize :lower }
  end

  def sign(payload)
    secret = Rails.application.credentials.twitch[:extension_secret]
    algorithm = Rails.application.credentials.jwt_algorithm

    # JWT.encode payload, secret, algorithm
    encode payload, secret, algorithm
  end

  # cache key representation of a broadcaster for JWT cache
  def cache_key
    "broadcaster_#{self.channel_id}_jwt"
  end

  # Generate a JWT for this broadcaster or fetch it from the cache if one exists
  def json_web_token
    expirationOffset = 60 * 60 * 1000

    now = Time.now.to_i
    expiration = now + expirationOffset

    # generated JWT will expire in one day from creation
    Rails.cache.fetch(self, expires_in: 1.days) do
      # Twitch JWT schema reference: https://dev.twitch.tv/docs/extensions/reference/#jwt-schema
      payload = {
        channel_id: self.channel_id.to_s,
        exp: expiration,
        iat: now,
        role: "external",
        user_id: Rails.application.credentials.twitch[:owner_user_id].to_s,
        pubsub_perms: {
          send: ["broadcast"],
        },
      }

      signed = sign(payload)
      return signed
    end
  end

  private

  def encode(payload, secret, algorithm = default_algorithm)
    timestamp = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S.000")

    #jwt header
    jwt_header = {
      alg: algorithm,
      typ: "JWT",
    }

    jwt_header_JSON = jwt_header.to_json
    jwt_header_UTF = jwt_header_JSON.encode("UTF-8")
    token_header = Base64.urlsafe_encode64(jwt_header_UTF)

    jwt_payload_JSON = payload.to_json
    jwt_payload_UTF = jwt_payload_JSON.encode("UTF-8")
    token_payload = Base64.urlsafe_encode64(jwt_payload_UTF, padding: false)

    signed_data = token_header + "." + token_payload

    digest = OpenSSL::Digest.new("sha256")
    bin_key = Base64.decode64(secret)
    instance = OpenSSL::HMAC.digest(digest, bin_key, signed_data)
    signature = Base64.urlsafe_encode64(instance, padding: false)

    complete_token = signed_data + "." + signature
    return complete_token
  end
end
