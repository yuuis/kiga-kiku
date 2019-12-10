require_relative '../config/boot'

class GeneratePreferenceGenreRankingForAllUsers
  def call
    users = UserRepository.new.all

    users.each do |user|
      GeneratePreferenceGenreRanking.new.call(user.id)
    end
  end
end
