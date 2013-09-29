# 'Agent' class for Rentlytics interview
# author: Andrew Ging

class Agent
  attr_accessor :month_data
  attr_reader :id
  
  def initialize(id)
    if (!id.nil? && Integer === id)
      @id = id
    else
      raise "Could not create new Agent. Wrong id format specified: '#{id}'"
    end
  end
end