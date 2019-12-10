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

  # rubocop:disable Metrics/MethodLength, Metrics/PerceivedComplexity
  def create_with_hash(shop_data)
    return nil if shop_data['id'].nil? || shop_data['genre'].nil? || shop_data['small_area'].nil?

    ShopRepository.new.create(
      id: shop_data['id'],
      genre_code: shop_data['genre']['code'] || '',
      sub_genre_code: 'G002',
      small_area_code: shop_data['small_area']['code'],
      large_area_code: shop_data['large_area']['code'],
      service_area_code: shop_data['service_area']['code'],
      budget_code: shop_data['budget']['code'] || '',
      name: shop_data['name'] || '',
      mobile_access: shop_data['mobile_access'] || '',
      address: shop_data['address'] || '',
      lng: shop_data['lng'] || '',
      lat: shop_data['lat'] || '',
      course: shop_data['course'] || '',
      show: shop_data['show'] || '',
      non_smoking: shop_data['non_smoking'] || '',
      horigotatsu: shop_data['horigotatsu'] || '',
      open: shop_data['open'] || '',
      card: shop_data['card'] || '',
      tatami: shop_data['tatami'] || '',
      charter: shop_data['charter'] || '',
      wifi: shop_data['wifi'] || '',
      shop_detail_memo: shop_data['shop_detail_memo'] || '',
      band: shop_data['band'] || '',
      karaoke: shop_data['karaoke'] || '',
      midnight: shop_data['midnight'] || '',
      urls: shop_data['urls']['pc'] || '',
      english: shop_data['english'] || '',
      lunch: shop_data['lunch'] || '',
      close: shop_data['close'] || '',
      budget_memo: shop_data['budget_memo'] || '',
      tv: shop_data['tv'] || '',
      private_room: shop_data['private_room'] || '',
      barrier_free: shop_data['barrier_free'] || '',
      child: shop_data['child'] || '',
      capacity: shop_data['capacity'] || '',
      pet: shop_data['pet'] || '',
      free_food: shop_data['free_food'] || '',
      free_drink: shop_data['free_drink'] || '',
      station_name: shop_data['station_name'] || ''
    )
  end
  # rubocop:enable Metrics/MethodLength, Metrics/PerceivedComplexity
end
