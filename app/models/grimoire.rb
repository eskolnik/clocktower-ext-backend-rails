class Grimoire < ApplicationRecord
  belongs_to :game_session

  # decode JSON or return empty JSON object if nil
  def parse(val, default = {})
    val.nil? ? default : JSON.parse(val)
  end

  def json_view
    return {
             "player_id": player_id,
             "is_host": is_host,
             "players": parse(players),
             "bluffs": parse(bluffs, []),
             "edition": parse(edition),
             "roles": parse(roles),
           }
  end
end
