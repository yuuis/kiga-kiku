Hanami::Model.migration do
  change do
    create_table :recommended_logs do
      primary_key :id
      foreign_key :user_id, :users, on_delete: :cascade, null: false

      column :search_words, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
