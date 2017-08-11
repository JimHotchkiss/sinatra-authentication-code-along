require 'pry'
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
      if user = User.find_by(email: email)
# if this finds a user object, then the user object will be assigned
# to this user variable, and the entire statement will be truthy
# if not, the entire thing, including the variable, will be equal to nil
        session[:email] = user.email
        binding.pry
# Then I set a session based on that
      else
        redirect '/login'
      end
    end

    def logout!
      session.clear
    end

  end

end
