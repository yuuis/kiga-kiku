namespace :preference do
  desc 'generate user preference shop genre ranking.'
  task :genre do
    require_relative '../batch/favorite_shop_genre_ranking'
    PreferenceShopGenreRanking.new.call
  end
end
