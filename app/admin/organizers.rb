ActiveAdmin.register User, as: "Organizer" do
  menu label: "Organizers"

  permit_params :name, :email, :phone, :password, :password_confirmation, userable_attributes: [:id, :website, :address]
  
  filter :name
  filter :email
  filter :phone
  filter :created_at
  filter :userable_of_Organizer_type_website, as: :string, label: 'Website'
  filter :userable_of_Organizer_type_address, as: :string, label: 'Address'


  controller do
    def scoped_collection
      User.where(userable_type: 'Organizer')
    end

    def new
      build_resource
      resource.userable_type = "Organizer"
      resource.userable = Organizer.new
      super
    end

    def update
      if params[:organizer][:password].blank? && params[:organizer][:password_confirmation].blank?
        params[:organizer].delete(:password)
        params[:organizer].delete(:password_confirmation)
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :phone
    column :created_at
    column :website do |user|
      user.userable&.website
    end
    column :address do |user|
      user.userable&.address
    end
    actions
  end

  form do |f|
    f.semantic_errors
    f.inputs "Account Details" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :password
      f.input :password_confirmation
      f.input :userable_type, as: :hidden, input_html: { value: 'Organizer' }
    end

    f.inputs "Organizer Details", for: :userable do |u|
      u.input :website
      u.input :address
    end
    f.actions
  end


  
end
