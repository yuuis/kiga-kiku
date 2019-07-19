# frozen_string_literal: true

class RecommendedShopRepository < Hanami::Repository
  associations do
    belongs_to :recommend_conversation
  end

  def find_by_conversation(conversation)
    recommended_shops.where(recommend_conversation_id: conversation.id).map_to(RecommendedShop).to_a
  end
end
