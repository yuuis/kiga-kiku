# frozen_string_literal: true

class ConditionRepository < Hanami::Repository
  associations do
    belongs_to :feedback
  end
end
