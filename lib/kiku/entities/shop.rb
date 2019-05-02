class Shop < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :code, Types::String
    attribute :name, Types::String
    attribute :genre_code, Types::String
    attribute :small_area_code, Types::String
  end
end
