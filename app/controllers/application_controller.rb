class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :snake_case_params

  # Handle OPTIONS preflight checks
  # Credit to jpbalarini https://gist.github.com/jpbalarini/54a1aa22ebb261af9d8bfd9a24e811f0
  before_action :cors_set_access_control_headers

  def cors_preflight_check
    return unless request.method == "OPTIONS"
    cors_set_access_control_headers
    render json: {}
  end

  def auth_header
    request.headers["Authorization"]
  end

  def decoded_token
    if !auth_header
      raise "Invalid Authorization Token"
    end

    auth = auth_header.split(" ")

    # Header must be prefixed with "Bearer"
    if auth[0] != "Bearer"
      raise "Invalid Authorization Token"
    end

    token = auth[1]
    secret = Rails.application.credentials.twitch[:extension_secret]
    algorithm = Rails.application.credentials.jwt_algorithm

    logger.info "TOKEN RECEIVED: #{token}"
    logger.info "SECRET #{secret}"

    # Use custom JS JWT library because Ruby's just doesn't work
    verify = JSON.parse(`node app/javascript/verify_jwt.js #{token} #{secret}`)
    logger.info "TOKEN VERIFIED: #{verify.to_s}"
    return verify
  end

  def jwt_auth
    begin
      token = decoded_token
      logger.info "decoded #{token}"

    rescue
      logger.error "failed to decode #{token}"
      # render :json => { error: "error", status: 400 }
      return false
    end

    if !token["valid"]
      # render :json => { error: "error", status: 400 }
      return false
    end
    return token["result"]
  end

  def sign(payload)
    secret = Rails.application.credentials.twitch[:extension_secret]
    algorithm = Rails.application.credentials.jwt_algorithm

    JWT.encode payload, secret, algorithm
  end

  protected

  def cors_set_access_control_headers
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "POST, GET, PUT, PATCH, DELETE, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Origin, Content-Type, Accept, Authorization, Token, " \
    "Auth-Token, Email, X-User-Token, X-User-Email, x-xsrf-token"
    response.headers["Access-Control-Max-Age"] = "1728000"
    response.headers["Access-Control-Allow-Credentials"] = true
  end

  def restrict_to_development
    head(:bad_request) unless Rails.env.development?
  end

  private

  # snake_case the query params and all other params
  # This is probably more hacky than it needs to be
  # TODO: investigate ActionController::Parameters class and see if we can override
  def snake_case_params
    params.deep_transform_keys!(&:underscore)
    request.parameters.deep_transform_keys!(&:underscore)
  end
end
