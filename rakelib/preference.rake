namespace :preference do
  desc 'generate user preference shop genre ranking.'
  task :genre do
    require_relative '../batch/generate_preference_genre_ranking_for_all_users'
    GeneratePreferenceGenreRankingForAllUsers.new.call
  end
end
