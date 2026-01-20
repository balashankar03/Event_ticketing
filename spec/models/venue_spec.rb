require 'rails_helper'

RSpec.describe Venue, type: :model do
  
  let(:venue) { create(:venue) }

  describe "Associations" do
   
    it "has many events" do
      create(:event, venue:venue)
      expect { venue.destroy }.to change(Event, :count).by(-1)
    end
  end

  describe "Validations" do
    it "is invalid without a name" do
      venue.name = nil
      expect(venue).not_to be_valid
      expect(venue.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an address" do
      venue.address = nil
      expect(venue).not_to be_valid
      expect(venue.errors[:address]).to include("can't be blank")
    end

    it "is invalid without a city" do
      venue.city = nil
      expect(venue).not_to be_valid
      expect(venue.errors[:city]).to include("can't be blank")
    end
  end

  describe ".ransackable_attributes" do
    it "returns a list of searchable columns" do
        expected_attributes = ["name", "city", "address", "capacity", "created_at", "updated_at"]
        expect(Venue.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe ".ransackable_associations" do
    it "returns a list of searchable columns" do
        expected_associations = ["events"]
        expect(Venue.ransackable_associations).to match_array(expected_associations)
    end
  end
  
end