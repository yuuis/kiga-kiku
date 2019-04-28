class ShopGenre < Hanami::Entity
  attributes do
    attribute :code, Types::Int
    attribute :name, Types::String
  end
end
