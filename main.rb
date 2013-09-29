# Exercise 1 for Rentlytics interview
# author: Andrew Ging
require 'date'
require_relative 'unit_type'
require_relative 'prospect'
require_relative 'agent'
require_relative 'file_getter'

class Event
  # Event names:
  SHOW                = 'Show'
  APPOINTMENT         = 'Appointment'
  LEASE_SIGNED        = 'LeaseSigned'  # considered closing on prospect
  SUBMIT_APPLICATION  = 'SubmitApplication'
  CANCEL_APPLICATION  = 'ApplicationCanceled'
  DENY_APPLICATION    = 'ApplicationDenied'
  APPROVE_APPLICATION = 'ApplicationApproved'
  REAPPLY             = 'ReApply'
  ASSIGN_UNIT         = 'AssignUnit'  # Also considered closing on prospect (TODO: need to handle NULL agent_id)
  RENT_OVERRIDE       = 'RentOverride'  #reset rent amount to current datestamp's
  EMAIL               = 'Email'
  CANCELED_GUEST      = 'CanceledGuest'
  REACTIVATED_GUEST   = 'ReactivatedGuest'
  WALK_IN             = 'WalkIn'
  CALL                = 'Call'
end

all_unit_types = FileGetter.get_market_rents_file
if defined?(all_unit_types)
  all_unit_types.each do |type|
    puts "unit_type: #{type.inspect}"
  end
end

all_prospects = FileGetter.get_prospect_events_file

puts "#{all_prospects.inspect}"

itar = 0
all_prospects.each do |prospect_array|
  prospect = prospect_array[1]
  if itar < 10
    agent_id = prospect.agent_id
    year_month = prospect.closing_date.strftime('%Y-%m')
    if agents[agent_id].nil?
      #create new agent
      #this_agent = Agent.new()
    else
      this_agent = agents[agent_id]      
      this_agent.month_data[year_month][:total_prospects] += 1
    end
    if prospect.closing_time
      avg_closing_time = this_agent.month_data[year_month][:avg_closing_time]
      closed_prospects = this_agent.month_data[year_month][:closed_prospects]
      new_avg_closing_time = (avg_closing_time * closed_prospects + prospect.closing_time) /
                                (closed_prospects + 1)
      this_agent.month_data[year_month][:avg_closing_time] = new_avg_closing_time
      this_agent.month_data[year_month][:closed_prospects] += 1
    end
      
  end
  itar += 1
end

agents.each do |agent|
  
end

# class MarketRent
  # attr_accessor :year, :month, :value
# end

# class PreviousMarketRent < MarketRent
# end

# class MarketRents
# end