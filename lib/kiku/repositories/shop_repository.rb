# frozen_string_literal: true

class ShopRepository < Hanami::Repository
  associations do
    belongs_to :shop_genre
    # belongs_to :small_area
    has_many :feedbacks
  end
end
