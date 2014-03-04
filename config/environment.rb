require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'standalone_migrations'

Bundler.require(:default)
Dir[File.expand_path('../../lib/**/*.rb', __FILE__)].each { |f| require f }

config = YAML.load_file(StandaloneMigrations::Configurator.new.config)[ENV['RAILS_ENV']]
ActiveRecord::Base.establish_connection(config)

I18n.enforce_available_locales = false