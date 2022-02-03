class GameSession < ApplicationRecord
  belongs_to :broadcaster

  has_many :grimoires
end
