class Feedback < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :user_id, Types::Int
    attribute :shop_id, Types::String
    attribute :feel, Types::Bool # false: bad true: good
  end
end
