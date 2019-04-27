class User < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :name, Types::String
    attribute :age, Types::Int
    attribute :gender, Types::Int
  end
end
