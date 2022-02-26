class BroadcastersController < ApplicationController
  before_action :restrict_to_development, :only => [:index]

  def index
    @broadcasters = Broadcaster.all
    render :json => @broadcasters
  end

  # GET /broadcasters/:channel_id
  def show
    token_data = jwt_auth

    cid = token_data["channel_id"]

    if cid != params[:id]
      render :json => { status: "error" }
      return
    end
      
    @broadcaster = Broadcaster.find_by(channel_id: params[:id])
    if (!@broadcaster)
      render :json => { status: "error" }
      return
    end

    render :json => @broadcaster&.json_view
  end

  # POST /broadcasters/
  def create
    token_data = jwt_auth

    cid = token_data["channel_id"]

    if cid != params[:id]
      render :json => { status: "error" }
      return
    end
      
    broadcaster = Broadcaster.find_by(channel_id: params[:channel_id]) || Broadcaster.new

    broadcaster.channel_id = params[:channel_id]
    broadcaster.secret_key = params[:secret_key]

    broadcaster.save
  end
end
