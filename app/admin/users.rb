ActiveAdmin.register User do

  menu label: "Users"
  actions :index, :show, :destroy 
  permit_params :name, :email, :phone, :userable_type, :userable_id, :password, :password_confirmation, userable_attributes: [:id, :website, :address, :date_of_birth, :city, :gender]
  
  controller do
    def scoped_collection
      super.includes(:userable)
    end
  end

  scope "Missing phone" do |users|
    users.where(phone: [nil, ''])
  end

  

  filter :name
  filter :email
  filter :phone
  filter :userable_type, as: :select, collection: ['Organizer', 'Participant']
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column "Role" do |user|
      user.userable_type
    end
    column "Details" do |user|
      case user.userable_type
      when 'Organizer'
        "Website: #{user.userable&.website}, Address: #{user.userable&.address}"
      when 'Participant'
        "DOB: #{user.userable&.date_of_birth}, City: #{user.userable&.city}, Gender: #{user.userable&.gender}"
      else
        "N/A"
      end
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :phone
      row :userable_type
    end

    if resource.organizer?
      panel "Organizer Details" do
        attributes_table_for resource.userable do
          row :website
          row :address
        end
      end
    elsif resource.participant?
      panel "Participant Details" do
        attributes_table_for resource.userable do
          row :date_of_birth
          row :city
          row :gender
        end
      end
    end
  end

end

