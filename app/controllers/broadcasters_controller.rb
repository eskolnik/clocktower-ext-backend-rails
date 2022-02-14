require "jwt"

class BroadcastersController < ApplicationController
  before_action :restrict_to_development, :only => [:index]

  def index
    @broadcasters = Broadcaster.all
    render :json => @broadcasters
  end

  # GET /broadcasters/:channel_id
  def show
    @broadcaster = Broadcaster.find_by(channel_id: params[:id])
    if (!@broadcaster)
      return false
    end
    render :json => @broadcaster&.json_view
  end

  # POST /broadcasters/
  def create
    broadcaster = Broadcaster.find_by(channel_id: params[:channel_id]) || Broadcaster.new

    broadcaster.channel_id = params[:channel_id]
    broadcaster.secret_key = params[:secret_key]

    broadcaster.save
  end
end
