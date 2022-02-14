class GrimoiresController < ApplicationController
  before_action :restrict_to_development, :only => [:index]

  # GET /grimoires
  def index
    @grimoires = Grimoire.all

    render :json => @grimoires.map(&:json_view).to_json
  end

  # GET /grimoires/:channel_id
  def show
    broadcaster = Broadcaster.find_by(channel_id: params[:id])

    if (!broadcaster)
      render :json => { status: "error", message: "Channel Not Found: #{params[:id]}" }
      return
    end

    grimoire = broadcaster&.game_session&.grimoire

    if (!grimoire)
      render :json => { status: "error", message: "Grimoire Not Found: #{params[:id]}" }
      return
    end

    render :json => grimoire.json_view.to_json
  end

  # POST /grimoires/
  def create
    # Find the matching game session for this player
    session = GameSession.find_by(session_id: request.params[:session], secret_key: request.params[:secret_key])

    if (!session)
      render :json => { status: "error" }
      return
    end

    grimoire = session.grimoire || Grimoire.new

    grimoire.player_id = request.params[:player_id] || grimoire.player_id || nil
    grimoire.is_host = request.params[:is_host] || grimoire.is_host || nil
    grimoire.players = request.params[:players].to_json || grimoire.players || nil
    grimoire.bluffs = request.params[:bluffs].to_json || grimoire.bluffs || nil
    grimoire.edition = request.params[:edition].to_json || grimoire.edition || nil
    grimoire.roles = request.params[:roles].to_json || grimoire.roles || nil
    grimoire.version = request.params[:version] || grimoire.version || nil

    grimoire.game_session = session

    grimoire.save
  end
end
