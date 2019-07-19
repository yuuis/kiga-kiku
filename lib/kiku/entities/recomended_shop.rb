class RecommendedShop < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :shop_id, Types::String
    attribute :recommend_conversation_id, Types::String
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end
end
