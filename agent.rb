# 'Agent' class for Rentlytics interview
# author: Andrew Ging

class Agent
  attr_accessor :month_data
  attr_reader :id
  
  def initialize(id)
    if (!id.nil?)# && Integer === id)
      @id = id
    else
      raise "Could not create new Agent. Wrong id format specified: '#{id}'"
    end
  end
  
  def self.process_prospects_for_agents(all_prospects)
    agents = {}
    itar = 0
    all_prospects.each do |prospect_array|
      prospect = prospect_array[1]
      if itar < 2500
        agent_id = prospect.agent_id
        year_month = prospect.last_date.strftime('%Y-%m')
        if agents[agent_id].nil?
          #create new agent
          this_agent = Agent.new(agent_id)
        else
          this_agent = agents[agent_id]
          if !this_agent.month_data.nil? && !this_agent.month_data[year_month][:total_prospects].nil?
            this_agent.month_data[year_month][:total_prospects] += 1
          else
            this_agent.month_data[year_month][:total_prospects] = 1
          end
        end
        if prospect.closing_time
          if !this_agent.month_data.nil? && !(this_agent.month_data[year_month][:avg_closing_time]).nil?
            avg_closing_time = this_agent.month_data[year_month][:avg_closing_time]
          else
            avg_closing_time = 0
          end
          if !this_agent.month_data.nil? && !this_agent.month_data[year_month][:closed_prospects].nil?
            closed_prospects = this_agent.month_data[year_month][:closed_prospects]
          else
            closed_prospects = 0
          end
          new_avg_closing_time = (avg_closing_time * closed_prospects + prospect.closing_time) /
                                    (closed_prospects + 1)
          this_agent.set_avg_closing_time(year_month, new_avg_closing_time)
          this_agent.increment_closed_prospects(year_month)
        end
          
      end
      itar += 1
    end
    return agents
  end
  
  def set_avg_closing_time(year_month, avg_closing_time)
    if @month_data.nil?
      @month_data = {year_month => {}}
    end
    @month_data[year_month][:avg_closing_time] = avg_closing_time
  end
  
  def increment_closed_prospects(year_month)
    if @month_data.nil?
      @month_data = {year_month => {}}
    end
    if @month_data[year_month][:closed_prospects].nil?
      @month_data[year_month][:closed_prospects] = 1
    else
      @month_data[year_month][:closed_prospects] += 1
    end
  end
end

