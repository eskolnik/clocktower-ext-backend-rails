class CreateGameSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :game_sessions do |t|
      t.belongs_to :broadcaster
      t.string :secret_key
      t.string :session_id
      t.string :player_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
