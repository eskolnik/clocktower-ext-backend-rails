class Api::V1::GameSessionsController < ApplicationController
  before_action :restrict_to_development, :only => [:index]

  def index
    sessions = GameSession.all

    render :json => sessions
  end

  # POST /game_sessions
  def create
    broadcaster = Broadcaster.find_by(secret_key: params[:secret_key])

    if (!broadcaster)
      render :json => { status: "error" }
      return
    end

    session = broadcaster.game_session || GameSession.new
    session.broadcaster = broadcaster

    session.secret_key = params[:secret_key]
    session.session_id = params[:session]
    session.player_id = params[:player_id]
    session.is_active = params[:is_active]

    session.save
  end
end
