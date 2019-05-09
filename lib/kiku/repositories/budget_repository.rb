# frozen_string_literal: true

class BudgetRepository < Hanami::Repository
  associations do
    has_many :shops
  end
end
