require 'rails_helper'

RSpec.describe Organizer, type: :model do
  let(:organizer) { create(:organizer) }

  describe "Associations" do
    it "has many events and destroys them on deletion" do
      create(:event, organizer: organizer)
      expect { organizer.destroy }.to change(Event, :count).by(-1)
    end

    it "has one user and destroys it on deletion" do
      create(:user, userable: organizer)
      expect { organizer.destroy }.to change(User, :count).by(-1)
    end
  end

  
    describe ".ransackable_attributes" do
      it "returns the allowed searchable columns" do
        expected_attributes = ["id", "website", "address", "created_at", "updated_at"]
        expect(Organizer.ransackable_attributes).to match_array(expected_attributes)
      end
    end

    describe ".ransackable_associations" do
      it "returns the allowed searchable associations" do
        expected_associations = ["events", "user"]
        expect(Organizer.ransackable_associations).to match_array(expected_associations)
      end
    end
  
end