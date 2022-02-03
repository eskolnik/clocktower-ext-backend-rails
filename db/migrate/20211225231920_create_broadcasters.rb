class CreateBroadcasters < ActiveRecord::Migration[7.0]
  def change
    create_table :broadcasters do |t|
      t.integer :channel_id
      t.string :secret_key

      t.timestamps
    end
  end
end
