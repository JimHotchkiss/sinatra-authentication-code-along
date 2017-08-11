class SessionsController < ApplicationController

  get '/login' do
    erb :'sessions/login'
  end

  post '/sessions' do
    session[:email] = params[:email]
    redirect to '/posts'
  end

end
