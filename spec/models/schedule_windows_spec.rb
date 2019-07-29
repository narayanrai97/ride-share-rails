require 'rails_helper'

RSpec.describe ScheduleWindow, type: :model do
  describe "Assocation" do
     it {should belong_to(:driver) } 
     it{should belong_to(:location) }
  end
end
