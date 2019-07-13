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

    words = user_like_words(user, Time.now.hour) if words.empty? && past_conditions.nil?

    @recommend_result = recommend(user, words, latitude, longitude, past_conditions)

    # TODO: お店が見つからなかったら、キーワードを無くして無理やりお店を出す
    binding.pry
    @recommend_result = recommend(user, [], latitude, longitude, past_conditions) if @recommend_result[:shops].empty? && words.empty? && past_conditions.nil?
  end

  private

  def recommend(user, search_word, latitude, longitude, past_conditions)
    conditions = {
      keyword: search_word.join(' ')
    }

    if past_conditions.nil?
      conditions = add_condition_tavern(conditions, Date.today)
      conditions = add_condition_midnight(conditions, Time.now.hour)
      conditions = add_condition_lunch(conditions, Time.now.hour)
      conditions = add_condition_budget(conditions, user)
      conditions = add_condition_range(conditions, latitude, longitude)
    else
      conditions = past_conditions
    end

    shops = get_shops(conditions)

    if shops.empty? && conditions.key?(:range) && conditions[:range] < 5
      return recommend(user, search_word, latitude, longitude, ConditionRepository.new.farther(conditions))
    end

    { shops: shops, conditions: conditions }
  end

  # 金曜、土曜であれば居酒屋を条件に足す
  def add_condition_tavern(conditions, today)
    return conditions if [0, 1, 2, 3, 4].include?(today.wday)

    conditions.merge(genre: 'G001')
  end

  # 時刻が深夜(22 ~ 27)であれば、深夜営業(食事も)していることを条件に足す
  def add_condition_midnight(conditions, hour)
    return conditions if time_range[hour] != :midnight

    conditions.merge(midnight_meal: 1)
  end

  # 時刻がお昼(11 ~ 13)であれば、ランチありを条件に足す
  def add_condition_lunch(conditions, hour)
    return conditions unless time_range[hour] != :noon

    conditions.merge(lunch: 1)
  end

  # ユーザのいる位置を条件に足す
  def add_condition_range(conditions, latitude, longitude)
    return conditions if latitude.nil? || longitude.nil?

    conditions.merge(lat: latitude, lng: longitude, range: 3)
  end

  # ユーザの年齢によって予算を条件に足す
  def add_condition_budget(conditions, user)
    return conditions if user.age.nil? || user.age > 35

    case user.age
    when 0..22 then conditions.merge(budget: 'B001') # ¥1501 ~ ¥2000
    when 23..29 then conditions.merge(budget: 'B002') # ¥2001 ~ ¥3000
    when 30..35 then conditions.merge(budget: 'B003') # ¥3001 ~ ¥4000
    else conditions.merge(budget: 'B008') # ¥4001 ~ ¥5000
    end

    conditions
  end

  # 時間帯によってキーワードを返す
  # TODO: 履歴やユーザの好みによってキーワードを最適化
  def keyword_by_hour(hour)
    case time_range[hour]
    when :midnight then %w[お酒 居酒屋].sample(1)
    when :morning then %w[モーニング コーヒー ブレックファースト 朝食 朝ごはん].sample(1)
    when :noon then %w[ラーメン ランチ カレー パスタ お昼ご飯].sample(1)
    when :after_noon then %w[ケーキ お菓子 おやつ 和菓子 紅茶 喫茶店].sample(1)
    when :night then %w[ディナー 夜ご飯 夕食 レストラン].sample(1)
    else ['焼肉'].sample(1)
    end
  end

  def user_like_words(user, hour)
    transactions = RecommendTransactionRepository.new.find_all_by_user_id(user.id)

    return keyword_by_hour(hour) if transactions.nil?

    conversation_repository = RecommendConversationRepository.new
    conversations = transactions.map { |transaction| conversation_repository.find_all_by_transaction(transaction) }.flatten

    return keyword_by_hour(hour) if conversations.nil?

    user_words = conversations.select { |conversation| time_range[conversation.created_at.hour + 9] == time_range[hour] }.map(&:user_word)
    ConditionRepository.new.more_conditions.merge(start: 'おい').each { |_, value| user_words.delete(value) }

    return keyword_by_hour(hour) if user_words.empty?

    [user_words.group_by { |item| item }.sort_by { |_, value| -value.size }.map(&:first).first]
  end

  def time_range
    {
      0 => :midnight, 1 => :midnight, 2 => :midnight, 3 => :midnight,
      4 => :morning, 5 => :morning, 6 => :morning, 7 => :morning, 8 => :morning, 9 => :morning, 10 => :morning,
      11 => :noon, 12 => :noon, 13 => :noon,
      14 => :after_noon, 15 => :after_noon, 16 => :after_noon, 17 => :after_noon,
      18 => :night, 19 => :night, 20 => :night, 21 => :night,
      22 => :midnight, 23 => :midnight, 24 => :midnight
    }
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
