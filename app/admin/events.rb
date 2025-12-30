ActiveAdmin.register Event do

permit_params :name, :description, :datetime, :organizer_id, :venue_id, :image, category_ids: [], ticket_tiers_attributes: [:id, :name, :price, :remaining, :_destroy]

index do
  selectable_column
  id_column
  column :name
  column :datetime
  column :organizer
  column :venue
  column :created_at
  column "Tiers" do |event|
    event.ticket_tiers.count
  end
  actions
end

filter :name
filter :venue
filter :organizer
filter :datetime

show do
  attributes_table do
    row :name
    row :description
    row :datetime
    row :organizer
    row :venue
    row :categories do |event|
      event.categories.map(&:name).join(", ")
    end
    row :image do |event|
      if event.image.attached?
        image_tag url_for(event.image), style: "max-width: 300px; height: auto;"
      else
        "No Image"
      end
    end
    row :created_at
    row :updated_at
  end

  panel "Ticket Tiers" do
    table_for event.ticket_tiers do
      column :name
      column :price do |tier|
        number_to_currency(tier.price)
      end
      column :remaining
    end
  end

  active_admin_comments
end

form do |f|
  f.semantic_errors
  f.inputs "Event Details" do
    f.input :name
    f.input :description
    f.input :datetime, as: :datetime_picker
    f.input :organizer
    f.input :venue
    f.input :categories, as: :check_boxes
    f.input :image, as: :file
  end
  f.inputs "Ticket Tiers" do
    f.has_many :ticket_tiers, allow_destroy: true, new_record: true do |t|
      t.input :name
      t.input :price
      t.input :remaining
    end
  end
  f.actions

end
end
