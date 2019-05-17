class UserWentShop < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :user_id, Types::Int
    attribute :shop_id, Types::Int
  end
end
