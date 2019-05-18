# frozen_string_literal: true

require 'hanami/interactor'

class UserWentShopRecent
  include Hanami::Interactor

  expose :shops

  def call(user_id)
    user = UserRepository.new.find(user_id)

    return nil if user.nil?

    shops = UserWentShopRepository.new.recent(user)
    shop_repository = ShopRepository.new

    @shops = shops.map do |shop|
      shop_repository.find(shop.shop_id).to_h
    end
  end
end
