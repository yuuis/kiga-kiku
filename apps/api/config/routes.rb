# frozen_string_literal: true

get '/shops', to: 'shops#recommend'
get '/went_shops/', to: 'shops#user_went'
get '/guess_like/', to: 'conditions#guess_like'
get '/guess_dislike/', to: 'conditions#guess_dislike'
get '/users', to: 'users#find'
get '/user_went', to: 'user_went_shops#create'

post '/locations', to: 'locations#create'
