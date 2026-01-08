
object @event
attributes :id, :name, :description, :

child :venue do
  attributes :id, :name, :address
end


child :ticket_tiers do
attributes :id, :name :price
end


