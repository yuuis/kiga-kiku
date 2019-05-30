# frozen_string_literal: true

class FeedbackRepository < Hanami::Repository
  associations do
    belongs_to :users
    belongs_to :shops
    has_many :conditions
  end

  def like_feedbacks(user)
    feedbacks.where(user_id: user.id).where(feel: true).as(Feedback).to_a
  end

  def dislike_feedbacks(user)
    feedbacks.where(user_id: user.id).where(feel: false).as(Feedback).to_a
  end
end
