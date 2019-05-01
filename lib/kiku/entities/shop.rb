class Shop < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :name, Types::String
    attribute :address, Types::String
    attribute :genre_code, Types::Int
  end
end
