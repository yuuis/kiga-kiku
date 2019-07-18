Hanami::Model.migration do
  change do
    create_table :recommended_shops do
      primary_key :id
      foreign_key :recommend_conversation_id, :recommend_conversations, on_delete: :cascade, null: false

      column :shop_id, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
