require_relative '../../config/boot'
require 'date'

class UserSeed
  def call
    UserRepository.new.create(name: 'taro', birthday: Date.new(2000, 1, 1), gender: 0)
  end
end
