ActiveAdmin.register User, as: "Participant" do
  menu label: "Participants"

  permit_params :name, :email, :phone, :userable_type, :password, :password_confirmation, userable_attributes: [:id, :date_of_birth, :city, :gender]
  
  scope :new_users do |users|
    users.where('created_at >= ?', 7.days.ago)
  end
  

  filter :name
  filter :email
  filter :phone
  filter :created_at
  filter :userable_of_Participant_type_date_of_birth, as: :date_range, label: 'Date of Birth'
  filter :userable_of_Participant_type_city, as: :string, label: 'City'
  filter :userable_of_Participant_type_gender, as: :select, collection: ['Male', 'Female', 'Other'],  label: 'Gender'



  controller do
    def scoped_collection
      User.where(userable_type: 'Participant')
    end

    def new
      build_resource
      resource.userable_type = "Participant"
      resource.userable = Participant.new
      super
    end

    def create
      @user=User.new(params[:user].except(:userable_attributes).permit(:name, :email, :phone, :password, :password_confirmation, :userable_type ))
      @user.userable=Participant.new(params[:user][:userable_attributes].permit(:date_of_birth, :city, :gender))
      if @user.save
        redirect_to admin_participants_path, notice: "Participant created successfully!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if params[:user][:password].blank?
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
    column :date_of_birth do |user|
      user.userable&.date_of_birth
    end
    column :city do |user|
      user.userable&.city
    end
    column :gender do |user|
      user.userable&.gender
    end
    column :created_at
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
      f.input :userable_type, as: :hidden, input_html: { value: 'Participant' }
    end

    f.inputs "Participant Details", for: :userable do |u|
      u.input :date_of_birth, as: :datepicker
      u.input :city
      u.input :gender, as: :select, collection: ['Male', 'Female', 'Other']
    end
    f.actions
  end
end