class PublicHoliday
  attr_reader :local_name

  def initialize(api_data)
    @local_name = api_data[:localName]
  end
end
