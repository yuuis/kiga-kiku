# frozen_string_literal: true

require 'hanami/interactor'
require 'date'

class MakeFeedback
  include Hanami::Interactor

  expose :feedback

  def call(user_id, shop_id, point)
    user = UserRepository.new.find(user_id)
    shop = ShopRepository.new.find(shop_id)

    return nil if user.nil? || shop.nil? || ![0, 1, 2, 3].include?(point)

    @feedback = make_feedback(user, shop, point)
  end

  private

  def make_feedback(user, shop, point)
    FeedbackRepository.new.create(user_id: user.id, shop_id: shop.id, point: point)
  end
end
