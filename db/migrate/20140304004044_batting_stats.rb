class BattingStats < ActiveRecord::Migration
  def up
    create_table :batting_stats do |t|
      t.integer   :player_id
      t.string    :team
      t.integer   :year
      t.integer   :games
      t.integer   :at_bats
      t.integer   :runs
      t.integer   :hits
      t.integer   :doubles
      t.integer   :triples
      t.integer   :home_runs
      t.integer   :runs_batted_in
      t.integer   :stolen_bases
      t.integer   :caught_stealing

      t.timestamps
    end

    add_index :batting_stats, [:player_id, :year, :team], unique: true
    add_index :batting_stats, :player_id
  end
  
  def down
    drop_table :batting_stats
  end
end