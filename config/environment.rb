require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'standalone_migrations'

Bundler.require(:default)

# recursively require all files in the ./lib folder and down that end in .rb
Dir.glob('./lib/*').each do |folder|
  Dir.glob(folder + "/*.rb").each do |file|
    require file
  end
end

config = YAML.load_file(StandaloneMigrations::Configurator.new.config)[ENV['RAILS_ENV']]
ActiveRecord::Base.establish_connection(config)