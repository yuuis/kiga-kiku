require_relative '../../config/boot'

class FeedbackSeed
  def call
    FeedbackRepository.new.create(user_id: 1, shop_id: 'J001051208', feel: true)
    FeedbackRepository.new.create(user_id: 1, shop_id: 'J001051208', feel: false)
  end
end
