require 'rails_helper'

RSpec.describe Ticket, type: :model do

  let(:ticket) { create(:ticket) }

  describe "Associations" do
    it "belongs to an order" do
      expect(ticket.order).to be_an(Order)
    end

    it "belongs to a ticket_tier" do
      expect(ticket.ticket_tier).to be_a(TicketTier)
    end

    
    it "has an event through the ticket tier" do
      
      expect(ticket.event).to eq(ticket.ticket_tier.event)
    end
  end

  describe "Callbacks" do
    it "generates a serial number before validation on create" do
      
      new_ticket = build(:ticket, serial_no: nil)
      
      new_ticket.valid? 
      
      expect(new_ticket.serial_no).to be_present
      expect(new_ticket.serial_no).to start_with("TIC-")
    end

    it "does not overwrite an existing serial number" do
      custom_sn = "TIC-CUSTOM123"
      new_ticket = create(:ticket, serial_no: custom_sn)
      
      expect(new_ticket.serial_no).to eq(custom_sn)
    end
  end

  describe "Validations" do
    it "is invalid if the serial number is not unique" do
      
      first_ticket = create(:ticket, serial_no: "TIC-UNIQUE123")
      
      
      second_ticket = build(:ticket, serial_no: "TIC-UNIQUE123")
      
      expect(second_ticket).not_to be_valid
      expect(second_ticket.errors[:serial_no]).to include("has already been taken")
    end
  end

  describe ".ransackable_attributes" do
    it "returns the allowed searchable columns" do
      expected_attributes = ["id","order_id","ticket_tier_id", "serial_no", "seat_info", "created_at", "updated_at"]
      expect(Ticket.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe ".ransackable_associations" do
    it "returns the allowed searchable associations" do
      expected_associations = ["order", "ticket_tier", "event"]
      expect(Ticket.ransackable_associations).to match_array(expected_associations)
    end
    end



end