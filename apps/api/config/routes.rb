# frozen_string_literal: true

get '/shops', to: 'shops#recommend'
get '/went_shops/', to: 'shops#user_went'
get '/guess_like/', to: 'conditions#guess_like'
get '/guess_dislike/', to: 'conditions#guess_dislike'
