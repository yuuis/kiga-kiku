# frozen_string_literal: true

class SmallAreaRepository < Hanami::Repository
  associations do
    has_many :shops
  end
end
