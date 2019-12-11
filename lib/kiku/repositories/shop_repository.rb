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
  def create_from_hash(raw_shop)
    return nil if raw_shop['id'].nil?

    if !raw_shop['genre'].nil? && ShopGenreRepository.new.find(raw_shop['genre']['code']).nil?
      ShopGenreRepository.new.create(
        code: raw_shop['genre']['code'],
        name: raw_shop['genre']['name']
      )
    end

    if !raw_shop['sub_genre'].nil? && ShopGenreRepository.new.find(raw_shop['sub_genre']['code']).nil?
      ShopGenreRepository.new.create(
        code: raw_shop['sub_genre']['code'],
        name: raw_shop['sub_genre']['name']
      )
    end

    if !raw_shop['small_area'].nil? && SmallAreaRepository.new.find(raw_shop['small_area']['code']).nil?
      SmallAreaRepository.new.create(
        code: raw_shop['small_area']['code'],
        name: raw_shop['small_area']['name']
      )
    end

    if !raw_shop['budget'].nil? && BudgetRepository.new.find(
      raw_shop['budget']['code']
    ).nil?
      BudgetRepository.new.create(
        code: raw_shop['budget']['code'],
        name: raw_shop['budget']['name']
      )
    end

    ShopRepository.new.create(
      id: raw_shop['id'],
      genre_code: raw_shop['genre']['code'] || '',
      sub_genre_code: 'G002',
      small_area_code: raw_shop['small_area']['code'] || '',
      large_area_code: raw_shop['large_area']['code'] || '',
      service_area_code: raw_shop['service_area']['code'] || '',
      budget_code: raw_shop['budget']['code'] || '',
      name: raw_shop['name'] || '',
      mobile_access: raw_shop['mobile_access'] || '',
      address: raw_shop['address'] || '',
      lng: raw_shop['lng'] || '',
      lat: raw_shop['lat'] || '',
      course: raw_shop['course'] || '',
      show: raw_shop['show'] || '',
      non_smoking: raw_shop['non_smoking'] || '',
      horigotatsu: raw_shop['horigotatsu'] || '',
      open: raw_shop['open'] || '',
      card: raw_shop['card'] || '',
      tatami: raw_shop['tatami'] || '',
      charter: raw_shop['charter'] || '',
      wifi: raw_shop['wifi'] || '',
      shop_detail_memo: raw_shop['shop_detail_memo'] || '',
      band: raw_shop['band'] || '',
      karaoke: raw_shop['karaoke'] || '',
      midnight: raw_shop['midnight'] || '',
      urls: raw_shop['urls']['pc'] || '',
      english: raw_shop['english'] || '',
      lunch: raw_shop['lunch'] || '',
      close: raw_shop['close'] || '',
      budget_memo: raw_shop['budget_memo'] || '',
      tv: raw_shop['tv'] || '',
      private_room: raw_shop['private_room'] || '',
      barrier_free: raw_shop['barrier_free'] || '',
      child: raw_shop['child'] || '',
      capacity: raw_shop['capacity'] || '',
      pet: raw_shop['pet'] || '',
      free_food: raw_shop['free_food'] || '',
      free_drink: raw_shop['free_drink'] || '',
      station_name: raw_shop['station_name'] || ''
    )
  end
  # rubocop:enable
end
