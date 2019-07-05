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

  def check_conditions(word, conditions)
    case word
    when more_conditions[:cheaper] then cheaper(conditions)
    when more_conditions[:more_expensive] then more_expensive(conditions)
    when more_conditions[:closer] then closer(conditions)
    when more_conditions[:farther] then farther(conditions)
    end
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

  private

  def budgets
    # TODO: 直書きしてるけど、DBにマスタデータが入っているので、金額順にして取得するほうが良い
    %w[B009 B010 B011 B001 B002 B003 B008 B004 B005 B006 B012 B013 B014]
  end
end
