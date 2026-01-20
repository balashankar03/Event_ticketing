require 'rails_helper'

RSpec.describe TicketTier, type: :model do
  let(:event) {create(:event)}
  let(:ticket_tier) { create(:ticket_tier, event: event) }

  describe "Associations" do
    it "belongs to an event" do
      
      expect(ticket_tier.event).to be_a(Event)
    end

    it "has many tickets" do
      
      create_list(:ticket, 2, ticket_tier: ticket_tier)
      
      expect(ticket_tier.tickets.count).to eq(2)
    end

    it "destroys associated tickets when the ticket_tier is deleted" do
      create(:ticket, ticket_tier: ticket_tier)
      
      expect { ticket_tier.destroy }.to change(Ticket, :count).by(-1)
    end
  end

  describe ".ransackable_attributes" do
    it "returns a list of searchable columns" do
        expected_attributes = ["id", "name", "price", "remaining", "available", "event_id", "created_at", "updated_at"]
        expect(TicketTier.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe ".ransackable_associations" do
    it "returns a list of searchable columns" do
        expected_associations = ["event", "tickets"]
        expect(TicketTier.ransackable_associations).to match_array(expected_associations)
    end
  end

  describe "Callbacks and Logic" do
    
    describe "#update_availability_status" do
      let(:ticket_tier) { build(:ticket_tier, available: true) }

      it "sets availability to false when remaining reaches 0" do
        ticket_tier.remaining = 0
        ticket_tier.save
        
        expect(ticket_tier.available).to be false
      end

      it "sets availability to false when remaining is less than 0" do
        ticket_tier.remaining = -5
        ticket_tier.save
        
        expect(ticket_tier.available).to be false
      end

      it "does not change availability if remaining is greater than 0" do
        ticket_tier.remaining = 10
        ticket_tier.available = true
        ticket_tier.save
        
        expect(ticket_tier.available).to be true
      end
    end

    describe "#set_default_availability" do
      it "sets available to true if it is currently nil" do
        build(:ticket_tier, available: nil)
        ticket_tier.save
        
        expect(ticket_tier.available).to be true
      end

      it "does not overwrite available if it is already false" do
        build(:ticket_tier, available: false)
        ticket_tier.save
        
        expect(ticket_tier.available).to be false
      end
    end
  end


  
  
end