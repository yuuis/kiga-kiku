class Feedback < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :user_id, Types::Int
    attribute :shop_id, Types::Int
    attribute :point, Types::Int
  end
end

