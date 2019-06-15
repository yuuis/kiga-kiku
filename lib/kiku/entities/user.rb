class User < Hanami::Entity
  attributes do
    attribute :id, Types::Int
    attribute :name, Types::String
    attribute :birthday, Types::Int
    attribute :gender, Types::Int
    attribute :married, Types::Bool
    attribute :have_children, Types::Bool
    attribute :smoker, Types::Bool
    attribute :job, Types::String
    attribute :created_at, Types::Time
    attribute :updated_at, Types::Time
  end

  def age
    require 'date'

    date_format = '%Y%m%d'
    birthday.nil? ? nil : ((Date.today.strftime(date_format).to_i - birthday.strftime(date_format).to_i) / 10_000)
  end
end
