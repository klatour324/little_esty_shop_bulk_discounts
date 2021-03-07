require "rails_helper"

RSpec.describe NagerDateService do
  it "exists" do
    nagerdate_service_data = NagerDateService.new("US")

    expect(nagerdate_service_data).to be_a(NagerDateService)
  end

  it "grabs the next public holidays for the US" do
    VCR.use_cassette("nager_data_service_next_public_holidays") do
      nagerdate_service_data = NagerDateService.new("US")
      public_holidays = nagerdate_service_data.next_public_holidays

      expect(public_holidays.count).to eq(3)
      expect(public_holidays.first.local_name).to eq("Memorial Day")
      expect(public_holidays[1].local_name).to eq("Independence Day")
      expect(public_holidays.last.local_name).to eq("Labor Day")
    end
  end
end
