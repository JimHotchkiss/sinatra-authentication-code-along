class PostController < ApplicationController

  get '/posts' do
    "A list of publicly available posts"
  end

  get '/posts/new' do
    # this will check if user is logged in
    if !logged_in?
      redirect to '/login' # redirect if they are. This works!
    else
      'A new post form' # rendering if they are
    end
  end

  get '/posts/:id/edit' do
    # here is where we would put the logic to see if user is logged in
    # but what we want, actually, is a helper method to ask that question
    if !logged_in?
      redirect '/login'
    else
      'An edit post form '
    end 
  end

end
