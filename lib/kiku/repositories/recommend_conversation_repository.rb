# frozen_string_literal: true

class RecommendConversationRepository < Hanami::Repository
  associations do
    belongs_to :recommend_transaction
  end

  def find_by_transaction(transaction)
    recommend_conversations.where(recommend_transaction_id: transaction[:id]).map_to(RecommendConversation).to_a.last
  end

  def find_all_by_transaction(transaction)
    id = transaction.kind_of?(Hash) ? transaction[:id] : transaction.id
    recommend_conversations.where(recommend_transaction_id: id).map_to(RecommendConversation).to_a
  end
end
