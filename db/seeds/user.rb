require_relative '../../config/boot'
require 'date'

class UserSeed
  def call
    UserRepository.new.create(name: 'taro', birthday: Date.new(2000, 1, 1), gender: 0)
    UserRepository.new.create(name: 'hanako', birthday: Date.new(2010, 2, 1), gender: 1)
  end
end
