# frozen_string_literal: true

class RecommendConversationRepository < Hanami::Repository
  associations do
    belongs_to :recommend_transaction
  end
end

