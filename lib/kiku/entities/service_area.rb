class ServiceArea < Hanami::Entity
  attributes do
    attribute :code, Types::String
    attribute :name, Types::String
  end
end
