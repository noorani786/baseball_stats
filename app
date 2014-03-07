#!/usr/bin/env ruby
require "./config/environment.rb"
require 'yaml'

input_file  = 'inputs/args.yml'

StatsRunner.run(YAML.load_file(input_file), $stdout)