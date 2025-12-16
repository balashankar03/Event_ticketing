class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :datetime
      t.references :venue, null: false, foreign_key: true
      t.references :organizer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
