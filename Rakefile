require 'yaml'
require 'logger'
require 'active_record'
require 'standalone_migrations'

StandaloneMigrations::Tasks.load_tasks

StandaloneMigrations::Configurator.environments_config do |env|

  env.on "production" do

    if (ENV['DATABASE_URL'])
      db = URI.parse(ENV['DATABASE_URL'])
      return {
        :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
        :host     => db.host,
        :username => db.user,
        :password => db.password,
        :database => db.path[1..-1],
        :encoding => 'utf8'
      }
    end

    nil
  end

end