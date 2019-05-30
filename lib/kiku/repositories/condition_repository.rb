# frozen_string_literal: true

class ConditionRepository < Hanami::Repository
  associations do
    belongs_to :feedback
  end

  def feedback_conditions(feedbacks)
    feedbacks.map { |feedback| conditions.where(feedback_id: feedback.id).map_to(Condition).to_a }
  end
end
