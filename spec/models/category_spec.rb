require 'rails_helper'

RSpec.describe Category, type: :model do
  
  let(:category) { create(:category) }

  describe "Associations" do

    it "has and belongs to many events" do
      event = create(:event)
      category.events << event
      
      expect(category.events).to include(event)
      expect(category.events.count).to eq(1)
    end
   end

   describe ".ransackable_attributes" do
    it "returns a list of searchable columns" do
        expected_attributes = ["id", "name", "created_at", "updated_at"]
        expect(Category.ransackable_attributes).to match_array(expected_attributes)
    end
    end

    describe ".ransackable_associations" do
    it "returns a list of searchable columns" do
        expected_associations = ["events"]
        expect(Category.ransackable_associations).to match_array(expected_associations)
    end
    end



  
end