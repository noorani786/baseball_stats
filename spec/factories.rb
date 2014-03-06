FactoryGirl.define do
  # rather than make up fake players and fake stats, lets create real players/stats 
  # by referencing http://espn.go.com/mlb/stats/batting/_/league/al/sort/homeRuns so that 
  # we easily test things like averages, percentages, etc. by simply comparing it with the numbers
  # on the website.
  
  factory :player do
    sequence(:player_legacy_id) { |n| "legacy#{n}" }
    sequence(:first_name) { |n| "First#{n}" }
    sequence(:last_name) { |n| "Last#{n}" }  
  end
  
  factory :batting_stat do
    player
    year 2000
    team 'Team A'
    at_bats 10  
    hits 10
    doubles 10
    singles 10
    home_runs 10
    runs_batted_in 10
    stolen_bases 10
    caught_stealing 10
  end
  
  factory :best_batting_stat_2012, class: BattingStat do
    player 
    year 2012
    team 'XXX'
    at_bats 100
    hits 80
    doubles 50
    singles 10
    home_runs 20
    runs_batted_in 50
    stolen_bases 5
    caught_stealing 0
  end
  
  factory :chris_davis, class: Player do
    player_legacy_id "davisc"
    first_name "Chris"
    last_name "Davis"
    # sequence(:player_legacy_id) { |n| n == 0 ? "legacy#{n}" }
    # sequence(:first_name) { |n| "First#{n}" }
    # sequence(:last_name) { |n| "Last#{n}" }
  end
  
  factory :miguel_cabrera, class: Player do
    player_legacy_id "cabreram"
    first_name "Miguel"
    last_name  "Davis"
  end
  
  factory :adam_dunn, class: Player do
    player_legacy_id "dumma"
    first_name "Adam"
    last_name  "Dunn"   
  end
  
  factory :chris_davis_batting_stat_2013, class: BattingStat do
    association :player, factory: :chris_davis
    year 2013
    team 'BAL'
    at_bats 584
    hits 167
    doubles 42
    singles 1
    home_runs 53
    runs_batted_in 138
    stolen_bases 4
    caught_stealing 1
  end
  
  factory :chris_davis_batting_stat_2012, class: BattingStat do
    association :player, factory: :chris_davis
    year 2012
    team 'BAL'
    at_bats 515
    hits 139
    doubles 20
    singles 0
    home_runs 33
    runs_batted_in 85
    stolen_bases 2
    caught_stealing 3
  end
  
   factory :miguel_cabrera_batting_stat_2013, class: BattingStat do
      association :player, factory: :miguel_cabrera
      year 2013
      team 'DET'
      at_bats 555
      hits 193
      doubles 26
      singles 1
      home_runs 44
      runs_batted_in 137
      stolen_bases 3
      caught_stealing 0
   end
   
   factory :miguel_cabrera_batting_stat_2012, class: BattingStat do
      association :player, factory: :miguel_cabrera
      year 2012
      team 'DET'
      at_bats 622
      hits 205
      doubles 40
      singles 0
      home_runs 44
      runs_batted_in 139
      stolen_bases 4
      caught_stealing 1
   end
   
   factory :adam_dunn_batting_stat_2013, class: BattingStat do
      association :player, factory: :adam_dunn
      year 2013
      team 'CHW'
      at_bats 525
      hits 115
      doubles 15
      singles 0
      home_runs 34
      runs_batted_in 86
      stolen_bases 1
      caught_stealing 1
   end
   
   factory :adam_dunn_batting_stat_2012, class: BattingStat do
      association :player, factory: :adam_dunn
      year 2012
      team 'CHW'
      at_bats 539
      hits 110
      doubles 19
      singles 0
      home_runs 41
      runs_batted_in 96
      stolen_bases 2
      caught_stealing 1
   end
  
  # factory :batting_stat do
  #   player
  #   sequence(:year)             { |n| "200#{n}".to_i }
  #   sequence(:team)             { |n| "Team #{n}" }
  #   sequence(:at_bats)          { |n| n + 10 }
  #   sequence(:hits)             { |n| n + 5 }
  #   sequence(:doubles)          { |n| n + 2 }
  #   sequence(:singles)          { |n| n + 1 } 
  #   sequence(:home_runs)        { |n| n + 3 }
  #   sequence(:runs_batted_in)   { |n| n + 5 }
  #   sequence(:stolen_bases)     { |n| n }
  #   sequence(:caught_stealing)  { |n| n }
  # end
end