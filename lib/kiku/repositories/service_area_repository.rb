# frozen_string_literal: true

class ServiceAreaRepository < Hanami::Repository
  associations do
    has_many :shops
  end
end

