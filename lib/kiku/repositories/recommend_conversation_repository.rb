# frozen_string_literal: true

class RecommendConversationRepository < Hanami::Repository
  associations do
    belongs_to :recommend_transaction
  end

  def find_by_transaction(transaction)
    recommend_conversations.where(transaction_id: transaction.id).map_to(RecommendConversation).to_a.last
  end
end
