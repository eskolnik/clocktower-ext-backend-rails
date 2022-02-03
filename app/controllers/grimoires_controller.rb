class GrimoiresController < ApplicationController

  # GET /grimoires
  def index
    @grimoires = Grimoire.all

    render :json => @grimoires
  end

  # GET /grimoires/:channel_id
  def show
    broadcaster = Broadcaster.find_by(channel_id: params[:channel_id])
    session = broadcaster.game_session

    @grimoires = session.grimoires

    render :json => @grimoires
  end

  # POST /grimoires/
  def create
    broadcaster = Broadcaster.find_by(channel_id: params[:channel_id])

    session = broadcaster.game_sessions
  end
end
