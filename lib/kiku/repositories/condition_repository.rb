# frozen_string_literal: true

class ConditionRepository < Hanami::Repository
  associations do
    belongs_to :feedback
  end

  def feedback_conditions(feed_backs)
    return nil if feed_backs.nil?

    feed_backs.map { |feed_back| conditions.where(feedback_id: feed_back.id).map_to(Condition).to_a }
  end

  # TODO: とりあえず固定で もっと~ になりそうなものを返す
  def more_conditions
    {
      cheaper: 'もっと安い',
      more_expensive: 'もっと高い',
      closer: 'もっと近い',
      farther: 'もっと遠い',
      now_location: '現在地を教える'
    }
  end

  def cheaper(conditions)
    past_budget_code = conditions[:budget].nil? ? 'B008' : conditions[:budget]
    conditions[:budget] = budgets[budgets.index(past_budget_code) - 1] unless past_budget_code == 'B009'
    conditions
  end

  def more_expensive(conditions)
    past_budget_code = conditions[:budget].nil? ? 'B008' : conditions[:budget]
    conditions[:budget] = budgets[budgets.index(past_budget_code) + 1] unless past_budget_code == 'B014'
    conditions
  end

  def closer(conditions)
    past_range = conditions[:range].nil? ? 0 : conditions[:range]
    conditions[:range] = past_range - 1 unless past_range == 1
    conditions
  end

  def farther(conditions)
    past_range = conditions[:range].nil? ? 0 : conditions[:range]
    conditions[:range] = past_range + 1 unless past_range == 5
    conditions
  end

  def add_condition(conditions, latitude = nil, longitude = nil)
    conditions = add_tavern(conditions)
    conditions = add_midnight(conditions, Time.now.hour)
    conditions = add_budget(conditions, user)
    add_range(conditions, latitude, longitude)
  end

  private

  def budgets
    # TODO: 直書きしてるけど、DBにマスタデータが入っているので、金額順にして取得するほうが良い
    %w[B009 B010 B011 B001 B002 B003 B008 B004 B005 B006 B012 B013 B014]
  end

  # 金曜、土曜であれば居酒屋を条件に足す
  def add_tavern(conditions)
    return conditions if [0, 1, 2, 3, 4].include?(Date.today.wday)

    conditions.merge(genre: 'G001')
  end

  # 現在時刻が21:00以降であれば、深夜営業(食事も)していることを条件に足す
  def add_midnight(conditions, hour)
    return conditions if hour.between?(2, 20)

    conditions.merge(midnight_meal: 1)
  end

  # 現在時刻が10:00 ~ 13:00であれば、ランチありを条件に足す
  def add_lunch(conditions)
    return conditions unless Time.now.hour.between?(10, 13)

    conditions.merge(lunch: 1)
  end

  # ユーザのいる位置を条件に足す
  def add_range(conditions, latitude, longitude)
    return conditions if latitude.nil? || longitude.nil?

    conditions.merge(lat: latitude, lng: longitude, range: 3)
  end

  # ユーザの年齢によって予算を条件に足す
  def add_budget(conditions, user)
    return conditions if user.age.nil? || user.age > 35

    case user.age
    when 0..22 then conditions.merge(budget: 'B001') # ¥1501 ~ ¥2000
    when 23..29 then conditions.merge(budget: 'B002') # ¥2001 ~ ¥3000
    when 30..35 then conditions.merge(budget: 'B003') # ¥3001 ~ ¥4000
    else conditions.merge(budget: 'B008') # ¥4001 ~ ¥5000
    end

    conditions
  end
end
