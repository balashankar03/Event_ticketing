class CreateParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :participants do |t|
      t.date :date_of_birth
      t.string :city
      t.string :gender

      t.timestamps
    end
  end
end
