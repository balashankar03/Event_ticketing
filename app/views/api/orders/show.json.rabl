collection @orders, root: "Orders", object_root: false
attributes :id

child :event => :order_event do
  attributes :id, :name, :description
end

child :tickets => :tickets_order do
  attributes :id, :seat_info, :serial_no, :ticket_tier_id
  
  glue :ticket_tier do
    attributes :name => :ticket_tier_name
  end
end