class BroadcastersController < ApplicationController
  def index
    @casters = Broadcaster.all
    render :json => @casters
  end

  # GET /broadcasters/:channel_id
  def show
    @broadcaster = Broadcaster.find_by(channel_id: params[:id])
    render :json => @broadcaster
  end

  # POST /broadcasters/
  def create
    broadcaster = Broadcaster.find_by(channel_id: params[:channel_id]) || Broadcaster.new

    broadcaster.channel_id = params[:channel_id]
    broadcaster.secret_key = params[:secret_key]

    broadcaster.save
  end
end
