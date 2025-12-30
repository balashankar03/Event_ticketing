ActiveAdmin.register Venue do

  permit_params :name, :address, :capacity, :city
  
  index do
    selectable_column
    id_column
    column :name
    column :address
    column :capacity
    column :city
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :address
      row :capacity
      row :city
      row :created_at
      row :updated_at
    end

    panel "Events at this Venue" do
      table_for venue.events do
        column :id
        column :name
        column :datetime
        column :created_at
        column :Actions do |event|
          link_to "View", admin_event_path(event)
        end
      end
    end
    active_admin_comments
  end
  
end
