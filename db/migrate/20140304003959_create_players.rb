class CreatePlayers < ActiveRecord::Migration
  def up
    create_table :players do |t|
      t.string    :player_legacy_id
      t.string    :first_name
      t.string    :last_name
      t.integer   :birth_year

      t.timestamps
    end

    add_index :players, :player_legacy_id, unique: true
  end
  
  def down
    drop_table :players
  end
end