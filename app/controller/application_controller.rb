class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'auth_demo_lv'
  end

  helpers do
    def logged_in?
#!! the double bang takes an object and turns it into T or F statement
      !!session[:email]
    end

    def login(email)
      session[:email] = email
    end

    def logout!
      session.clear
    end

  end

end
