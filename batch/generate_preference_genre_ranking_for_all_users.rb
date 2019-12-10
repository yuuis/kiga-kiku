require_relative '../config/boot'

class GeneratePreferenceGenreRankingForAllUsers
  def call
    users = UserRepository.new.all

    GeneratePreferenceGenreRanking.new.call(users.first.id)

    # users.each do |user|
    #   SpecifyLocations.new.call(user.id)
    # end
  end
end
