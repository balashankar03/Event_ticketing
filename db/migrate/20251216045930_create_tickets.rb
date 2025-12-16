class CreateTickets < ActiveRecord::Migration[7.2]
  def change
    create_table :tickets do |t|
      t.string :serial_no
      t.string :seat_info
      t.references :order, null: false, foreign_key: true
      t.references :ticket_tier, null: false, foreign_key: true

      t.timestamps
    end
  end
end
