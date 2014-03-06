#!/usr/bin/env ruby
require "./config/environment.rb"
require 'yaml'

StatsRunner.run(YAML.load_file('inputs/args.yml'), $stdout)