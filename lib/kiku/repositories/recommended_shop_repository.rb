# frozen_string_literal: true

class RecommendedShopRepository < Hanami::Repository
  associations do
    belongs_to :recommend_log
  end
end
