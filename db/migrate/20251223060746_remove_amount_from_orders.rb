class RemoveAmountFromOrders < ActiveRecord::Migration[7.2]
  def change
    remove_column :orders, :amount, :integer
  end
end
