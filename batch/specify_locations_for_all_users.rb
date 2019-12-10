require_relative '../config/boot'

class SpecifyLocationsForAllUsers
  def call
    users = UserRepository.new.all

    users.each do |user|
      SpecifyLocations.new.call(user.id)
    end
  end
end
