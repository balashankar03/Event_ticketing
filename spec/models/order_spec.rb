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

  #describe "Validations" do
   # it "is valid with a status and associations" do
      
    #  expect(order).to be_valid
    #end

    #it "is invalid without a status" do
      
     # order.status = nil
      #expect(order).not_to be_valid
    #end
  #end
  
end