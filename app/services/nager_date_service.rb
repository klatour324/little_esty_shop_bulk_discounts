class NagerDateService < ApiService
  def initialize(country_code)
    @country_code = country_code
  end

  def next_public_holidays
    url = "https://date.nager.at/Api/v2/NextPublicHolidays/#{@country_code}"
    nager_data = get_data(url)
    nager_data[0..2].map do |public_holiday|
      PublicHoliday.new(public_holiday)
    end
  end
end
