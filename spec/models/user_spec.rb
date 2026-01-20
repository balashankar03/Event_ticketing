require 'rails_helper'

RSpec.describe User, type: :model do

  subject { build(:user, :for_participant) }

  describe "Associations" do

    it "can be created as a participant" do
      user = create(:user, :for_participant)
      expect(user.userable).to be_a(Participant)
      expect(user.userable.city).to be_present
    end

    it "can be created as an organizer" do
      user = create(:user, :for_organizer)
      expect(user.userable).to be_a(Organizer)
      expect(user.userable.website).to include("http")
    end
  end

  describe "Validations" do
    it "is invalid without an email" do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "is invalid if email is not unique" do
      create(:user, email: "test@example.com")
      duplicate = build(:user, email: "test@example.com")
      expect(duplicate).not_to be_valid
    end
  end

  describe "Helper Methods" do

    let(:organizer_user) { create(:user, :for_organizer) }
    let(:participant_user) { create(:user, :for_participant) }

    describe "#organizer?" do
      it "returns true for organizers" do
        expect(organizer_user.organizer?).to be true
      end
      it "returns false for participants" do
        expect(participant_user.organizer?).to be false
      end
    end

    describe "#participant?" do
      it "returns true for participants" do
        expect(participant_user.participant?).to be true
      end
      it "returns false for organizers" do
        expect(organizer_user.participant?).to be false
      end
    end

  end

  describe "Callbacks" do
    it "downcases email before saving" do
      user = create(:user, email: "HELLO@World.com")
      expect(user.email).to eq("hello@world.com")
    end
  end

   describe ".ransackable_attributes" do
    it "returns a list of searchable columns" do
        expected_attributes = ["id", "name", "email", "phone", "created_at", "updated_at", "userable_type", "userable_id"]
        expect(User.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe ".ransackable_associations" do
    it "returns a list of searchable columns" do
        expected_associations =["userable"]
        expect(User.ransackable_associations).to match_array(expected_associations)
    end
  end

end