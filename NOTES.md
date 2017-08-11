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
  * gem 'shotgun'
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

**** Able to connect to server and put out Hello World ****

~ make a new 'sessions' file
  * app/controller/sessions_controller.rb
~ now, make the views director and session folder
  * app/views/sessions/login.html

*** we've mounted the controller in config.ru, however, our
*** sessions-controller is not mounted, so, in config.ru we
*** need to mount sessions_
    ## Also remember, in browser, /login ##

** Authentication **

~ form in login.erb, asking 'what is your email?'
  * <input  type="text" name="email">
*** Make another controller ***
  * app/controller/post_controller.rb
    !! Remember: mount new controller, in config.ru, 'use'
*** Now make a UsersController, and mount it ***
  * app/controller/users_controller.rb

*** Back to the login-form ***
~ 'action' - where this data is going?
  * action='/sessions' method='POST'
  * now make my post '/sessions' route
  * with raise.params.inspect
!! this now tells us that login is communicating !!
  * with error: doesn't know email => ""
  * now if I enter an email it will read that   
  * email.  That's good.  

~ now I want to take our params[:email], and
~ set it equal to session[:email]!
~ and now redirect to '/posts'
!! So, session[:email] was not registering
!! the problem was in application_controller, and was
!! a type. It was 'set :session_secret, 'auth_demo_lv'
** Works now **
~ now we want to check is the user is logged in.  
  * posts_controller.rb get '/posts/new'
~ while we're at it, build a '/logout', in sessions_controller.rb
## now we've stubbed out a fake login, now let's add protection ##
~ make a new route in posts_controller.rb
  * get '/posts/:id/edit' do
!! however, what we want is to build helper methods to check log in
~ build a helper method is accessible across all controllers
  * application_controller: def logged_in?
    !! !!session[:email]
## Side note: you can take !! and turn an object into a T/F statement. For instance.
  * def true?
     !!self
    end
  * now you could ask 7.true? => true, nil.true? => false
~ now replace the older, longer, logic with logged_in? method
~ test this out by going to '/posts' in the browser
  * so if I go to '/posts/new' without logging in
  * it directs me to '/login'
  * once I log in, it takes me to welcome page
  * if I go to '/posts/new' it redirects me to 'A new post form'
~ session[:email] = email is saying log in this user with this email
~ lets build login and logout methods
  * we abstract away the logic and make new helper methods
~ now let's build more method in ApplicationController
  * def login(email)
     session[:email] = email
    end
  * def logout
     session.clear
    end

~ to confirm this is all working, within shotgun
  * so if I go to '/posts/new' without logging in
  * it directs me to '/login'
  * once I log in, it takes me to welcome page
  * if I go to '/posts/new' it redirects me to 'A new post form'
  * /login
  * /logout
~ NOW, we are going to get into authenticate
~ Avi's notes:
  1. I need users
    * URLs - would like to have
      * GET '/signup' => see a form
      * POST '/users' => actually create users
    * DATABASE
      * To to make users table to store email
        * rake db:create_migration NAME=create_users
        * create_table in db/migrate/CreateUsers
        * user model: app/models/user.rb
          !! remember: User < ActiveRecord::Base
        * migrate database
          !! rake db:migrate
        * test it by: rake console ~ User.create(:email => jon.email)
  2. I need to give users passwords
  3. Then need to be able to find user using their password
  4. Change login system to use their email and password to authenticate
~ Now, we've been able to populate out db
~ We want to add functionality to our app, to test the users email
~ added a loop in our login method, working well

*** Now we need to address the password ***
~ ActiveRecord has a SecurePassword method
  * Documentation: http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
~ Need to add gem 'bcrypt', '~> 3.1.7' to our Gemfile
~ We have to add a migration
  * rake db:create_migration NAME=add_passwords_to_users
~ Now add_column :users, :password_digest, :string
~ Then rake db:migrate
~ Now has_secure_password to User class
  * This effectively gives us 5 additional methods! Yay
~ Now I make a user with a password to see how the password is scrambled
!! Following is an example, set password w/ .password
  * u = User.new
  * u.password = "hello@example.come"
  * password_digest:
  "$2a$10$3rTucAzy3Bbjab1fuv3G3uN4MS9lD9O9AB95XZljN3.LDMTdvEJ8G"
  * .authenticate('some_password')
~ So we want to add this security functionality to our login loop
  * we want to add: .authenticate('some_password')
  * we have to change '/sessions' to include params[:password]
  * update form to include password input
!! @ 1:07 Avi starts to build out signup and registering
