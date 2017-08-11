Building a Sinatra app starting with file structure
~ bundle init (in terminal)
  * this will give me a Gemfile
~ now make a config.ru
  * so when I type in 'rackup config.ru' this will define the
    stack of my web application, that's gonna start a server
    and be able to respond to request
~ touch config.ru
~ the first the config.ru needs to do is to load an environment
  * require_relative './config/environment' (in config.ru)
~ make my config directory and my environment.rb file
~ now, in environment we want to:
  * require 'bundler'
  * Bundler.require
~ now, go to Gemfile, and add some gem files
  * gem 'sinatra'
  * gem 'sqlite3'
  * gem 'activerecord', :require => "active_record"
  * gem 'rake'
  * gem 'pry'
  * gem 'sinatra-activerecord'
  * gem 'require_all'
~ now that I have bundler, go to my environment
  * require 'bundler'
  * Bundler.require
  * ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'db/development.sqlite'
    )
  * require_all 'app'
~ now, make my db directory
~ now, make my app directory
~ now, make a Rakefile
~ in the Rakefile
  * require_relative './config/environment'
  * require 'sinatra/activerecord/rake'
  * task :console do
      Pry.start
    end
~ now, make a controller directory/application-controller file
  * app/controller/application-controller.rb
  * class ApplicationController < Sinatra::Base

      configure do
        set :public_folder, 'public'
        set :views, 'app/views'
      end

      get '/' do
        'Hello World'
      end
    end  # (This is in the application-controller)
~ now, in config.ru, we want to 'mount' the controller
  * if ActiveRecord::Migrator.needs_migration?
     raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
    end

    use Rack::MethodOverride
    run ApplicationController
~ now, enable sessions in application-controller
  * enable :sessions
    set :sessions_secret, 'carcollection'
