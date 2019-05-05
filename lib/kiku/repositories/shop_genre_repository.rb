# frozen_string_literal: true

class ShopGenreRepository < Hanami::Repository
  associations do
    has_many :shops
  end
end
