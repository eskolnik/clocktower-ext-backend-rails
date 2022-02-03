class GameSessionsController < ApplicationController
  def index
    sessions = GameSession.all

    render :json => sessions
  end

  # POST /game_sessions
  def create
    session = GameSession.new

    if (params[:secret_key])
      broadcaster = Broadcaster.find_by(secret_key: params[:secret_key])
      session.broadcaster = broadcaster
    end

    session.secret_key = params[:secret_key]
    session.session_id = params[:session_id]
    session.player_id = params[:player_id]
    session.is_active = params[:is_active]

    session.save
  end

  def update
  end

  def destroy
  end

  def show
    # session = GameSession.find_by(channel_id: )
  end
end
