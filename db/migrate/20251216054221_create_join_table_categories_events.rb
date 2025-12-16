class CreateJoinTableCategoriesEvents < ActiveRecord::Migration[7.2]
  def change
    create_join_table :categories, :events do |t|
      t.index [:category_id, :event_id]
      t.index [:event_id, :category_id]
    end
  end
end
