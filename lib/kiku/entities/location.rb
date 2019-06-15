class Location < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :user_id, Types::String
    attribute :latitude, Types::String
    attribute :longitude, Types::String
    attribute :activity_type, Types::String
    attribute :altitude, Types::String
    attribute :uuid, Types::String

    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end
end
