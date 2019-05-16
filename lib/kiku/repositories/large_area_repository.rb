# frozen_string_literal: true

class LargeAreaRepository < Hanami::Repository
  self.relation = :large_areas

  associations do
    has_many :shops
  end
end

