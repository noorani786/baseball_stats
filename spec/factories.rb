FactoryGirl.define do
  factory :player do
    sequence(:player_legacy_id) { |n| "legacy#{n}" }
    sequence(:first_name) { |n| "First#{n}" }
    sequence(:last_name) { |n| "Last#{n}" }  
  end
  
  factory :batting_stat do
    player
    year 2000
    team 'team A'
    at_bats 10  
    hits 10
    doubles 10
    triples 10
    home_runs 10
    runs_batted_in 10
    stolen_bases 10
    caught_stealing 10
  end
  
  # rather than make up fake players and fake stats, lets create real players/stats 
  # by referencing http://espn.go.com/mlb/stats/batting/_/league/al/sort/homeRuns so that 
  # we easily test things like averages, percentages, etc. by simply comparing it with the numbers
  # on the website.
  factory :miguel_c, class: BattingStat do
    player
    year 2013
    team 'DET'
    at_bats 555
    runs 103
    hits 193
    doubles 26
    triples 1
    home_runs 44
    runs_batted_in 137
    stolen_bases 3
    caught_stealing 0
  end
  
  factory :miguel_c_COL, class: BattingStat do
    player
    year 2013
    team 'COL'
    at_bats 555
    runs 103
    hits 193
    doubles 26
    triples 1
    home_runs 44
    runs_batted_in 137
    stolen_bases 3
    caught_stealing 0
  end
  
  factory :max_s, class: BattingStat do
    player
    year 2013
    team 'DET'
    at_bats 3
    runs 0
    hits 1
    doubles 1
    triples 0
    home_runs 0
    runs_batted_in 1
    stolen_bases 0
    caught_stealing 0
  end
  
  factory :torii_h, class: BattingStat do
    player
    year 2013
    team 'DET'
    at_bats 606
    runs 90
    hits 184
    doubles 37
    triples 5
    home_runs 17
    runs_batted_in 84
    stolen_bases 3
    caught_stealing 0
  end
  
  factory :jhonny_p, class: BattingStat do
    player
    year 2013
    team 'DET'
    at_bats 409
    runs 50
    hits 124
    doubles 30
    triples 0
    home_runs 11
    runs_batted_in 55
    stolen_bases 3
    caught_stealing 0
  end
  
  
  factory :chris_davis_batting_stat_2013, class: BattingStat do
    association :player, factory: :chris_davis
    year 2013
    team 'BAL'
    at_bats 584
    hits 167
    doubles 42
    triples 1
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
    triples 0
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
      triples 1
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
      triples 0
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
      triples 0
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
      triples 0
      home_runs 41
      runs_batted_in 96
      stolen_bases 2
      caught_stealing 1
   end
end