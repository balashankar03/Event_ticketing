class CreateOrganizers < ActiveRecord::Migration[7.2]
  def change
    create_table :organizers do |t|
      t.string :website
      t.string :address

      t.timestamps
    end
  end
end
