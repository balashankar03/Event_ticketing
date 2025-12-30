ActiveAdmin.register User do

  permit_params :name, :email, :phone, :userable_type, :userable_id, :password, :password_confirmation, userable_attributes: [:id, :website, :address, :date_of_birth, :city, :gender]
  
  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
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
    column :userable_type
    column :created_at
    actions
  end


  form do |f|
    f.semantic_errors
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :userable_type, as: :select, collection: ['Organizer', 'Participant'], include_blank: false

      if f.object.userable


end
