Hanami::Model.migration do
  change do
    create_table :recommended_logs do
      primary_key :id

      column :user_id, Integer, null: false
      column :day_of_the_week, Integer, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
