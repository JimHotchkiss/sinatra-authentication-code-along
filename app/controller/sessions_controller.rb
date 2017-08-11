class SessionsController < ApplicationController

  get '/login' do
    erb :'sessions/login'
  end

  post '/sessions' do
    login(params[:email])
    redirect '/posts' # This is suppose to say 'A list of publically...'
  end

  get '/logout' do
    logout!
    redirect '/login' # Avi has it redirect to '/posts', I did '/login'
  end

end
