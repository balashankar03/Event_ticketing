ActiveAdmin.register Category do

  permit_params :name, event_ids:[]

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
    end

    panel "Events" do
      table_for category.events do
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

  
end
