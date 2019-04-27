class RecommendedShop < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :shop_id, Types::String
  end
end
