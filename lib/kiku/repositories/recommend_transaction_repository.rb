# frozen_string_literal: true

class RecommendTransactionRepository < Hanami::Repository
  associations do
    belongs_to :user
    has_many :recommend_conversations
  end
end
