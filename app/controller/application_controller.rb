class ApplicationController < Sinatra::Base 

  configure do 
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, 'carcollection'
  end 

  get '/' do 
    'Hello World'
  end 
  
end 