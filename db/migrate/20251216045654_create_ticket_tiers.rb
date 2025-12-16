class CreateTicketTiers < ActiveRecord::Migration[7.2]
  def change
    create_table :ticket_tiers do |t|
      t.string :name
      t.decimal :price
      t.boolean :available
      t.integer :remaining
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
