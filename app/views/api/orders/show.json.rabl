collection @orders, root: "Orders", object_root: false

attributes :id

child :event => :order_event do
  attributes :id, :name, :description
end



