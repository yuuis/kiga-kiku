# frozen_string_literal: true

require 'hanami/interactor'
require 'date'

class RecommendShop
  include Hanami::Interactor

  expose :recommend_result

  # TODO: とりあえず緯度/経度は八王子にする
  def call(user_id, words = [], latitude = '35.65562', longitude = '139.3366642', past_conditions = nil)
    user = UserRepository.new.find(user_id)
    return nil if user.nil?

    words = get_timely_keywords unless words.empty? && past_conditions.nil?

    @recommend_result = recommend(user, words, latitude, longitude, past_conditions)
  end

  private

  def recommend(user, search_word, latitude, longitude, past_conditions)
    conditions = {
      keyword: search_word.join(' ')
    }

    if past_conditions.nil?
      conditions = ConditionRepository.new.add_condition(conditions, latitude, longitude)
    else
      conditions = past_conditions
    end

    shops = get_shops(conditions)

    return recommend(user, search_word, latitude, longitude, ConditionRepository.new.farther(conditions)) if shops.empty? && conditions.key?(:range) && conditions[:range] < 5

    { shops: shops, conditions: conditions }
  end

  # 時間帯によってキーワードを返す
  # TODO: 履歴やユーザの好みによってキーワードを最適化
  def get_timely_keywords
    words = []
    case Time.now.hour
    when 22..24, 0..3 then words << ["お酒", "居酒屋"].sample
    when 4..10 then words << ["モーニング", "コーヒー", "ブレックファースト", "朝食", "朝ごはん"].sample
    when 11..13 then words << ["ラーメン", "ランチ", "カレー", "パスタ", "お昼ご飯"].sample
    when 14..17 then words << ["ケーキ", "お菓子", "おやつ", "和菓子", "紅茶", "喫茶店"].sample
    when 18..21 then words << ["ディナー", "夜ご飯", "夕食", "レストラン"].sample
    else words << ["焼肉"].sample
    end
  end

  def get_shops(conditions)
    require 'net/http'
    require 'json'
    require 'uri'

    uri = URI.parse(ENV['HOTPEPPER_HOST'])
    http = Net::HTTP.new(uri.host, uri.port)

    params = {
      key: ENV['HOTPEPPER_API_KEY'],
      format: 'json',
      count: 3
    }.merge(conditions)

    response = http.get(uri.path + '/gourmet/v1?' + URI.encode_www_form(params))

    return nil if response.code != '200'

    JSON.parse(response.body)['results']['shop']
  end
end
