# frozen_string_literal: true

class RecommendTransactionRepository < Hanami::Repository
  associations do
    belongs_to :user
    has_many :recommend_conversations
  end

  def find_by_user_id(user_id)
    transaction_expire_time = 15
    recommend_transaction = recommend_transactions.where(user_id: user_id).last
    return nil if (Time.now - recommend_transaction) / 60 >  transaction_expire_time

    recommend_transaction
  end
end
