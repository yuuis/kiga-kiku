# frozen_string_literal: true

require 'hanami/interactor'

class GuessLikeCondition
  include Hanami::Interactor

  expose :conditions

  def guess_like(user_id)
    user = UserRepository.new.find(user_id)

    return nil if user.nil?

    @conditions = guess_like(user)
  end

  def guess_dislike(user_id)
    user = UserRepository.new.find(user_id)

    return nil if user.nil?

    @conditions = guess_dislike(user)
  end

  private

  def guess(user)
    # userが行ったお店を全て取得する
    # 行ったお店の中から、条件の数を求める
    # 求めた物の中から、x個を連想配列にして返す
  end
end
