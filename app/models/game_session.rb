class GameSession < ApplicationRecord
  belongs_to :broadcaster

  has_one :grimoire
end
