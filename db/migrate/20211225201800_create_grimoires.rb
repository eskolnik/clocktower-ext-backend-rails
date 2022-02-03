class CreateGrimoires < ActiveRecord::Migration[7.0]
  def change
    create_table :grimoires do |t|
      t.belongs_to :game_session
      t.string :player_id
      t.boolean :is_host
      t.text :players
      t.text :bluffs
      t.text :edition
      t.text :roles
      t.integer :version

      t.timestamps
    end
  end
end
