class RecommendedShop < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :shop_id, Types::String
    attribute :feed_back, TrueClass
  end
end
