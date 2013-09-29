# 'UnitType' class for Rentlytics interview
# author: Andrew Ging

class UnitType
  attr_accessor :id, :PreviousMarketRents, :MarketRents
  
  def initialize(id, attributes = {})
    @id = id
    @PreviousMarketRents = attributes[:previous_market_rent] if Hash === attributes[:previous_market_rent]
    @MarketRents = attributes[:market_rent] if Hash === attributes[:market_rent]
  end
  
  def add_previous_market_rent(yearmonth, value)
    @PreviousMarketRents[yearmonth] = value
  end
  
  def add_market_rent(yearmonth, value)
    @MarketRents[yearmonth] = value
  end
  
  def inspect
    output = "UnitType id: #{@id}, \nPMRs: "
    @PreviousMarketRents.each_pair do |date, value|
      output += "PMR: #{date}=>#{value}\n"
    end
    output += "MRs: "
    @MarketRents.each_pair do |date, value|
      output += "MR: #{date}=>#{value}\n"
    end
    return output
  end
end

