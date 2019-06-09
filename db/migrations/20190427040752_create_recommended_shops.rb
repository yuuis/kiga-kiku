Hanami::Model.migration do
  change do
    create_table :recommended_shops do
      primary_key :id
      foreign_key :shop_id, :shops, on_delete: :cascade, null: false, type: String
      foreign_key :recommend_conversation_id, :recommend_conversations, on_delete: :cascade, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
