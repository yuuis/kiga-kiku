# frozen_string_literal: true

class ShopRepository < Hanami::Repository
  associations do
    has_many :feedbacks

    belongs_to :shop_genre
    # belongs_to :small_area
    # belongs_to :large_area
    # belongs_to :service_area
    belongs_to :budget
  end
end
