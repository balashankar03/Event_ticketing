ActiveAdmin.register Ticket do
  permit_params :order_id, :ticket_tier_id, :seat_info

  index do
    selectable_column
    id_column
    column :serial_no
    column :order
    column :ticket_tier
    column :seat_info
    column :created_at
    actions
  end

  filter :serial_no
  filter :order
  filter :ticket_tier
  filter :created_at

  show do
    attributes_table do
      row :id
      row :serial_no
      row :order
      row :ticket_tier
      row :seat_info
      row :created_at
      row :updated_at
    end
    panel "Event Details" do
      table_for ticket.event do
      column :id
      column :name
      column :description
      column :datetime
      column :venue
      column :organizer
      column :created_at
      column :updated_at
    end
  end
end

  form do |f|
    f.inputs do
      f.input :order
      f.input :ticket_tier, as: :select, collection: ticket.event.ticket_tiers
      f.input :seat_info
    end
    f.actions
  end
  
end
