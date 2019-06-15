class Condition < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :feedback_id, Types::Int
    attribute :conditions, Types::String
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end
end
