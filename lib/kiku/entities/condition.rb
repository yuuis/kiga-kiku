class Condition < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :feedback_id, Types::Int
    attribute :conditions, Types::String
  end
end
