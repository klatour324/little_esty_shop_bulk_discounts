class PublicHoliday
  attr_reader :local_name,
              :date

  def initialize(api_data)
    @local_name = api_data[:localName]
    @date = api_data[:date]
  end
end
