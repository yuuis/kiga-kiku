# frozen_string_literal: true

class ServiceAreaRepository < Hanami::Repository
  self.relation = :service_areas

  associations do
    has_many :shops
  end
end

