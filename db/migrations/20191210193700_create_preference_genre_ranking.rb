Hanami::Model.migration do
  change do
    create_table :preference_genre_rankings do
      column :user_id, Integer, null: false
      column :order_index, Integer, nill: false
      column :shop_genre_id, String, null: false

      index %i[user_id order_index shop_genre_id], name: :user_order_shop_genre_id

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
