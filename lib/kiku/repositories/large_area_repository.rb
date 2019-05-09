# frozen_string_literal: true

class LargeAreaRepository < Hanami::Repository
  associations do
    has_many :shops
  end
end

