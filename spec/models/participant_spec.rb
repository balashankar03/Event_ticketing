require 'rails_helper'

RSpec.describe Participant, type: :model do
  let(:participant) { create(:participant) }

  describe "Associations" do
    it "has many orders and destroys them on deletion" do
      create(:order, participant: participant)
      expect { participant.destroy }.to change(Order, :count).by(-1)
    end

    it "has many tickets through orders" do
      order = create(:order, participant: participant)
      ticket = create(:ticket, order: order)
      expect(participant.tickets).to include(ticket)
    end

    it "has many events through orders" do
      event = create(:event)
      create(:order, participant: participant, event: event)
      expect(participant.events).to include(event)
    end

    it "has one user and destroys it on deletion" do
      user = create(:user, userable: participant)
      expect { participant.destroy }.to change(User, :count).by(-1)
    end
  end

  describe "Validations" do
    it "is invalid without a city" do
      participant.city = nil
      expect(participant).not_to be_valid
      expect(participant.errors[:city]).to include("can't be blank")
    end

    it "is invalid without a gender" do
      participant.gender = nil
      expect(participant).not_to be_valid
      expect(participant.errors[:gender]).to include("can't be blank")
    end
  end

  describe "Ransack Searchability" do
    describe ".ransackable_attributes" do
      it "returns the allowed searchable columns" do
        expected_attributes = ["id", "date_of_birth", "city", "gender", "created_at", "updated_at"]
        expect(Participant.ransackable_attributes).to match_array(expected_attributes)
      end
    end

    describe ".ransackable_associations" do
      it "returns the allowed searchable associations" do
        expected_associations = ["orders", "tickets", "user"]
        expect(Participant.ransackable_associations).to match_array(expected_associations)
      end
    end
  end
end