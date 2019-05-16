# frozen_string_literal: true

require 'hanami/interactor'

class GuessLikeCondition
  include Hanami::Interactor

  expose :conditions

  def call(user_id)
    user = UserRepository.new.find(user_id)

    return nil if user.nil?

    @conditions
  end

  private

  def make_feedback(user, shop, feel, conditions)
    feedback = FeedbackRepository.new.create(user_id: user.id, shop_id: shop.id, feel: feel)
    ConditionRepository.new.create(feedback_id: feedback.id, conditions: conditions)
  end
end
