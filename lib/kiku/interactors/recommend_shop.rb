# frozen_string_literal: true

require 'hanami/interactor'
require 'date'

class RecommendShop
  include Hanami::Interactor

  expose :shops

  def call(user_id, words)
    user = UserRepository.new.find(user_id)

    return nil if user.nil?

    @shops = recommend(user, words)
  end

  private

  def recommend(user, search_word)
    conditions = {
      # 'small_area' => '',
      # 'genre' => '',
      # 'card' => 0,
      keyword: search_word.join(' ')
    }

    conditions = add_condition_tavern(conditions)
    conditions = add_condition_midnight(conditions)
    conditions = add_condition_budget(conditions, user)

    # TODO: ユーザのフィードバックの良い条件をconditionsに足す

    get_shops(conditions)
  end

  # 金曜、土曜であれば居酒屋を条件に足す
  def add_condition_tavern(conditions)
    return conditions if [0, 1, 2, 3, 4].include?(Date.today.wday)

    conditions.merge(genre: 'G001')
  end

  # 現在時刻が21:00以降であれば、深夜営業(食事も)していることを条件に足す
  def add_condition_midnight(conditions)
    return conditions if Time.now.hour.between?(2, 20)

    conditions.merge(midnight_meal: 1)
  end

  # 現在時刻が10:00 ~ 13:00であれば、ランチありを条件に足す
  def add_condition_lunch(conditions)
    return conditions unless Time.now.hour.between?(10, 13)

    conditions.merge(lunch: 1)
  end

  # ユーザの年齢によって予算を条件に足す
  def add_condition_budget(conditions, user)
    age = user.age

    return conditions if age > 35

    case age
    when 0..22 then conditions.merge(budget: 'B001') # ¥1501 ~ ¥2000
    when 23..29 then conditions.merge(budget: 'B002') # ¥2001 ~ ¥3000
    when 30..35 then conditions.merge(budget: 'B003') # ¥3001 ~ ¥4000
    else conditions.merge(budget: 'B008') # ¥4001 ~ ¥5000
    end

    conditions
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
