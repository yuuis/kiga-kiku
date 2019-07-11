# frozen_string_literal: true

require 'hanami/interactor'

class GuessCondition
  include Hanami::Interactor

  expose :conditions

  def like_conditions(user_id)
    user = UserRepository.new.find(user_id)

    return nil if user.nil?

    @conditions = guess_like(user)
  end

  def dislike_conditions(user_id)
    user = UserRepository.new.find(user_id)

    return nil if user.nil?

    @conditions = guess_dislike(user)
  end

  private

  def guess_like(user)
    # get shops user went
    # calculate points from user went shops
    # return 3 items larger point after hashing

    shops = get_shops(user)
    points = calculate(shops)
    points[:other].max_by(3) { |_item1, item2| item2 }.to_h
  end

  def guess_dislike(user)
    # get shops user went
    # calculate points from user went shops
    # return items smaller than went shop count * 1/3 after hashing

    shops = get_shops(user)
    points = calculate(shops)
    points[:other].select { |_key, point| point > shops.count / 3 }
  end

  def get_shops(user)
    shops = UserWentShopRepository.new.findby_user_id(user.id)
    shop_repository = ShopRepository.new

    shops.map do |shop|
      shop_repository.find(shop.shop_id)
    end
  end

  # ゴリゴリ計算やってるところだからゆるして
  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/LineLength
  def calculate(shops)
    points = {
      genre: {},
      sub_genre: {},
      large_area: {},
      small_area: {},
      service_area: {},
      budget: {},
      other: {
        cource: 0,
        show: 0,
        non_smoking: 0,
        horigotatsu: 0,
        open: 0,
        card: 0,
        tatami: 0,
        charter: 0,
        wifi: 0,
        shop_detail_memo: 0,
        band: 0,
        karaoke: 0,
        midnight: 0,
        urls: 0,
        english: 0,
        lunch: 0,
        close: 0,
        budget_memo: 0,
        tv: 0,
        private_room: 0,
        barrier_free: 0,
        child: 0,
        capacity: 0,
        pet: 0,
        free_food: 0,
        free_drink: 0,
        station_name: 0
      }
    }

    shops.each do |shop|
      points[:genre][shop.genre_code] = points[:genre][shop.genre_code] ? points[:genre][shop.genre_code] + 1 : 1
      points[:sub_genre][shop.sub_genre_code] = points[:sub_genre][shop.sub_genre_code] ? points[:sub_genre][shop.sub_genre_code] + 1 : 1
      points[:large_area][shop.large_area_code] = points[:large_area][shop.large_area_code] ? points[:large_area][shop.large_area_code] + 1 : 1
      points[:small_area][shop.small_area_code] = points[:small_area][shop.small_area_code] ? points[:small_area][shop.small_area_code] + 1 : 1
      points[:service_area][shop.service_area_code] = points[:service_area][shop.service_area_code] ? points[:service_area][shop.service_area_code] + 1 : 1
      points[:budget][shop.budget_code] = points[:budget][shop.budget_code] ? points[:budget][shop.budget_code] + 1 : 1

      points[:other][:cource] += 1 if shop.cource.include?('あり')
      points[:other][:show] += 1 if shop.show.include?('あり')
      points[:other][:non_smoking] += 1 if shop.non_smoking.include?('あり')
      points[:other][:horigotatsu] += 1 if shop.horigotatsu.include?('あり')
      points[:other][:card] += 1 if shop.card.include?('利用可')
      points[:other][:tatami] += 1 if shop.tatami.include?('あり')
      points[:other][:charter] += 1 if shop.charter.include?('貸切可')
      points[:other][:wifi] += 1 if shop.wifi.include?('あり')
      points[:other][:band] += 1 unless shop.band.include?('不可')
      points[:other][:karaoke] += 1 if shop.karaoke.include?('あり')
      points[:other][:midnight] += 1 if shop.midnight.include?('営業している')
      points[:other][:english] += 1 if shop.english.include?('あり')
      points[:other][:lunch] += 1 if shop.lunch.include?('あり')
      points[:other][:tv] += 1 if shop.tv.include?('あり')
      points[:other][:private_room] += 1 if shop.private_room.include?('あり')
      points[:other][:barrier_free] += 1 if shop.barrier_free.include?('あり')
      points[:other][:child] += 1 if shop.child.include?('お子様連れOK') || shop.child.include?('お子様連れ歓迎')
      points[:other][:pet] += 1 unless shop.pet.include?('不可')
      points[:other][:free_food] += 1 if shop.free_food.include?('あり')
      points[:other][:free_drink] += 1 if shop.free_drink.include?('あり')
    end

    points
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/LineLength
end
