class RecommendedShop < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :shop, Types::String
    attribute :recommend_conversation_id, Types::String
  end
end
