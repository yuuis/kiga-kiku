# frozen_string_literal: true

class SmallAreaRepository < Hanami::Repository
  self.relation = :small_areas

  associations do
    has_many :shops
  end
end
