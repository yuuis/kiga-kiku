# frozen_string_literal: true

class ConditionRepository < Hanami::Repository
  associations do
    belongs_to :feedback
  end

  def maybe_like_conditions(user_id)
  end

  def maybe_dislike_conditions(user_id)
  end
end
