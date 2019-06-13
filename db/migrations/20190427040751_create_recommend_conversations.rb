Hanami::Model.migration do
  change do
    create_table :recommend_conversations do
      primary_key :id
      foreign_key :recommend_transaction_id, :recommend_transactions, on_delete: :cascade

      column :conditions, String
      column :user_word, String
      column :bot_word, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
