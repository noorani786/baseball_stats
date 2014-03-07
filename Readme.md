# Setup Instructions

## Pre-requisites

1. Ruby 2.1
1. Bundler
1. Sqlite

## Setting up and running the application

1. Clone this repository
1. Run 'bundle install'.  This will install the necessary gems.
1. Run 'rake db:migrate' followed by 'rake db:seed'.  This will create and seed the database. Note: 'rake db:seed' CAN be run multiple times without having any adverse effects.
1. Run 'ruby app'. This will run the application and print out the batting statistics.

## Configuration options

1. 'rake db:seed' uses the 'inputs/Master-small.csv' and 'inputs/Batting-07-12.csv' files.  Change these files to modify the seed data.
1. You can configure input parameters for computing the various statistics by making modifications to the 'inputs/args.yml' file.

## Running the specs

1. Run 'rake db:migrate DB=test' to setup the test database.
1. Run 'rspec'.  All of the specs should pass.

## Pushing to Prod

1. The app assumes that your DB connection to PROD is stored in an environment variable.  In particular the ENV variable to set the database URL is 'DATABASE_URL'.  Be sure to set this variable to the URL where your production database resides after pushing the codebase to production.  In the event that you are using another strategy for connecting to the production database, replace lines 12 - 22 inside Rakefile with your specific strategy.

## Notes and Comments

1.  Use of 'lib' instead of 'app': I have put all the code-related files inside the 'lib' folder.  In Rails this folder is typically named 'app'.  I decided to call it 'lib' to indicate that in the future we can extract this out into a gem so it can be used by multiple applications (ex. console, web, etc.)

1.  When uploading players via db:seed, I decided to skip those records that don't contain a playerID. Here are the reasons why:
    - Assumption is that all players inside batting_stat have an ID thus we create the player record if it missing.  
    - If we start to create our own IDs there is no guarantee that they won't clash with existing IDs as the file is further processed.
    - Re-processing the file becomes problematic since there is no way to guarantee uniqueness.  For example, if I create the ID 'brown01' for
        ,,,Brown record
      then the next time around when I am re-processing the file and it has new entries:
        brown01,1984,,Brown and
        ,,,Brown,
      I will have no way of knowing that ",,,Brown" is the existing entry and "brown01,1984,,Brown" is the new entry.

1.  The doc suggested that there is a triple crown winner for 2012.  However, according to the provided input file we end up with no winners. Here is why:
  - Miguel Carbrera is the winner for the AL league whereas the file contains statistics across leagues
  - Melky Cabrera has a higher batting average (.346) but he was disqualified in the middle of 2012.  Since we are taking into account both non-qualified and qualified players Melky ends up as the player with the highest batting player.
  - Because we aren't calculating triple crown for a specific league, the following players
  has a higher batting average than Miguel Carbrera:
    - Joey Votto at .337
  
1. When computing the triple crown winner we need to apply the rule exclude any players with a low a_bats count.  Otherwise a player with at_bats=1 and hits=1 will end up with the highest batting average.
    