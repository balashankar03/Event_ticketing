require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create(:event) }

  describe "Associations" do
    it "belongs to an organizer" do
      expect(event.organizer).to be_an(Organizer)
    end

    it "belongs to a venue" do
      expect(event.venue).to be_an(Venue)
    end

    it "has many ticket_tiers" do
      create_list(:ticket_tier, 2, event: event)
      expect(event.ticket_tiers.count).to eq(2)
    end

    it "has and belongs to many categories" do
      event_with_cats = create(:event, :with_categories)
      expect(event_with_cats.categories.count).to be >= 1
    end
  end

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(event).to be_valid
    end

    it "is invalid without a name" do
      event.name = nil
      expect(event).not_to be_valid
      expect(event.errors[:name]).to include("can't be blank")
    end

    it "is invalid without a description" do
      event.description = nil
      expect(event).not_to be_valid
      expect(event.errors[:description]).to include("can't be blank")
    end

    it "is invalid without a datetime" do
      event.datetime = nil
      expect(event).not_to be_valid
    end

  end


  describe "Custom Logic" do
    it "is identified as a past event if the date has passed" do
      event = build(:event, :past)
      expect(event).not_to be_valid
      expect(event.errors[:datetime]).to include("can't be in the past")
    end

  end

  describe ".search" do

  let!(:rock_event) { create(:event, name: "Rock Concert 2026") }
  let!(:jazz_event) { create(:event, name: "Midnight Jazz") }

  it "returns events that match the query (case-insensitive)" do
    results = Event.search("rock")
    
    expect(results).to include(rock_event)
    expect(results).not_to include(jazz_event)
  end

  it "returns events that match a partial query" do
    results = Event.search("Mid")
    
    expect(results).to include(jazz_event)
    expect(results).not_to include(rock_event)
  end

  it "returns all events if the query is an empty string" do
    results = Event.search("")
    
    expect(results.count).to eq(2)
    expect(results).to include(rock_event, jazz_event)
  end

  it "returns all events if the query is nil" do
    results = Event.search(nil)
    
    expect(results.count).to eq(2)
  end

  it "returns an empty collection if no match is found" do
    results = Event.search("Classical")
    
    expect(results).to be_empty
  end
  end

  describe ".ransackable_attributes" do
    it "returns a list of searchable columns" do
        expected_attributes = ["id", "name", "datetime", "description","organizer_id", "venue_id","created_at", "updated_at"]
        expect(Event.ransackable_attributes).to match_array(expected_attributes)
  end
    end

  describe ".ransackable_associations" do
    it "returns a list of searchable columns" do
        expected_associations = ["categories", "image_attachment", "image_blob", "orders", "organizer", "ticket_tiers", "tickets", "venue"]
        expect(Event.ransackable_associations).to match_array(expected_associations)
    end
  end


end