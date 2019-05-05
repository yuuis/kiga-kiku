# frozen_string_literal: true

class RecommendLogRepository < Hanami::Repository
  associations do
    belongs_to :user
    has_many :recommended_shops
  end
end
