collection @participants, root: "participants", object_root: false

glue :user => :user do
  attributes :id, :name, :email, :phone
end
attributes :id, :date_of_birth, :gender, :city




