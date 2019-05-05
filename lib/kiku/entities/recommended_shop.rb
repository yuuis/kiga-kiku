class RecommendedShop < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :shop_id, Types::String
    attribute :recommend_log_id, Types::Int
    attribute :feed_back, Types::Bool
  end
end
