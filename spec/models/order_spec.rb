require 'rails_helper'

RSpec.describe Order, type: :model do
  
  let(:order) { create(:order) }

  describe "Associations" do
    it "belongs to an event" do
      
      expect(order.event).to be_a(Event)
    end

    it "belongs to a participant" do

      expect(order.participant).to be_a(Participant)
    end

    it "has many tickets" do
      
      create_list(:ticket, 2, order: order)
      
      expect(order.tickets.count).to eq(2)
    end

    it "destroys associated tickets when the order is deleted" do
      create(:ticket, order: order)
      
      expect { order.destroy }.to change(Ticket, :count).by(-1)
    end
  end

  describe ".ransackable_attributes" do
    it "returns a list of searchable columns" do
        expected_attributes = ["id", "status", "participant_id", "created_at", "updated_at"]
        expect(Orders.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe ".ransackable_associations" do
    it "returns a list of searchable columns" do
        expected_associations = ["events", "participant", "tickets"]
        expect(Orders.ransackable_associations).to match_array(expected_associations)
    end
  end
  
end