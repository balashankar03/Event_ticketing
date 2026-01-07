ActiveAdmin.register Order do

  permit_params :status


  index do
    selectable_column
    id_column
    column :status
    column :event
    column :participant
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :status
      row :event
      row :participant
      row :created_at
      row :updated_at
    end

    panel "Tickets" do
      table_for order.tickets do
        column :id
        column :ticket_tier
        column :serial_no
        column :seat_info
        column :created_at
        column :updated_at
      end
    end
  end

end


