# 'Prospect' class for Rentlytics interview
# author: Andrew Ging

class Prospect
  attr_accessor :id, :initial_date, :unit_type_id, :closing_date, :agent_id, :source, :last_date
  
  def closing_time
    if !@closing_date.nil? && !@initial_date.nil?
      difference = (@closing_date - @initial_date).to_i
      if difference >= 0
        return difference
      else
        raise "Error: closing_time is negative for prospect: #{@id}, difference = #{difference}"
        # TODO: Possibly just do this if diff is negative: return (-1) * difference
      end
    else
      return false # indicates that closing_time doesn't exist for prospect
    end
  end
  
  def self.process_prospect_row(prospects = {}, columns)
    if columns.length < 6
      raise "#process_prospect_row requires an array of 6 elements, only #{columns.length} received"
    elsif !defined?(prospects)
      raise "#process_prospect_row requires a prospects hash"
    end
    
    columns = columns.map {|col| col.gsub('"', '')}  # remove double-quotes
    prospect_id, datestamp, event_name, agent_id, source, unit_type_id = columns
    event_date = Date.parse(datestamp)  
    unit_type_id.chomp!
    
    if prospects[prospect_id].nil?
      this_prospect = Prospect.new(prospect_id, event_date, agent_id, 
                                    source, unit_type_id, event_date)
      #this_prospect
    else
      this_prospect = prospects[prospect_id]
      this_prospect.last_date= event_date
    end
    
    case event_name
      when Event::SHOW
        this_prospect.initial_date= event_date
        if event_date == this_prospect.initial_date
          # i.e. updated or was the same date to begin with
          this_prospect.source= source
        end
      when Event::APPOINTMENT
        this_prospect.initial_date= event_date
        if event_date == this_prospect.initial_date
          # i.e. updated or was the same date to begin with
          this_prospect.source= source
        end
      when Event::LEASE_SIGNED
        this_prospect.closing_date= event_date
        this_prospect.agent_id= agent_id, event_name
        puts "event_name == #{event_name}, closing_date == #{this_prospect.closing_date}"
      when Event::SUBMIT_APPLICATION
        this_prospect.initial_date= event_date
        if event_date == this_prospect.initial_date
          # i.e. updated or was the same date to begin with
          this_prospect.source= source
        end
      when Event::CANCEL_APPLICATION
      when Event::DENY_APPLICATION
      when Event::APPROVE_APPLICATION
      when Event::REAPPLY
      when Event::ASSIGN_UNIT
        this_prospect.closing_date= event_date
        this_prospect.agent_id= agent_id, event_name
      when Event::RENT_OVERRIDE
        # Update rent amount to current date
      when Event::EMAIL
        this_prospect.initial_date= event_date
        if event_date == this_prospect.initial_date
          # i.e. updated or was the same date to begin with
          this_prospect.source= source
        end
      when Event::CANCELED_GUEST
      when Event::REACTIVATED_GUEST
      when Event::WALK_IN
        this_prospect.initial_date= event_date
        if event_date == this_prospect.initial_date
          # i.e. updated or was the same date to begin with
          this_prospect.source= source
        end
      when Event::CALL
        this_prospect.initial_date= event_date
        if event_date == this_prospect.initial_date
          # i.e. updated or was the same date to begin with
          this_prospect.source= source
        end
      else
        raise "Unrecognised event_name: #{event_name}"
    end
    
    return this_prospect
  end
  
  def initial_date=(new_date)
    # TODO: check input new_date to make sure it's a Date
    if @initial_date.nil? || new_date < @initial_date
      @initial_date = new_date    
    end
  end
  
  def source=(potentially_oldest_source)
    # if we come across a diff source for this prospect marked with an
    #  earlier datestamp, replace the source with potentially_oldest_source
    #  NB: This should only be called if above comment is true
    if !potentially_oldest_source.nil? && (@source.nil? || potentially_oldest_source != @source)
      @source = potentially_oldest_source
    end
  end
  
  def closing_date=(new_date)
    # TODO: check input new_date to make sure it's a Date
    if @closing_date.nil? || (new_date > @closing_date)
      @closing_date = new_date
    end
  end
  
  def last_date=(new_date)
    return if Date !== new_date
    if @last_date.nil? || (new_date > @last_date)
      @last_date = new_date
    end
  end
  
  def agent_id=(new_id, event_name=nil)
    return unless (new_id.is_a? Integer)
    
    if (event_name == Event::LEASE_SIGNED || event_name == Event::ASSIGN_UNIT) && 
        (@agent_id.nil? || new_id != @agent_id)
      @agent_id = new_id
    elsif event_name.nil? && @agent_id.nil?
      @agent_id = new_id
    end
  end
  
  def initialize(prospect_id, event_date, agent_id, source, unit_type_id)
    @id = prospect_id
    event_date = Date.parse(event_date) unless Date === event_date
    @initial_date = event_date
    @agent_id = agent_id
    @source = source
    @unit_type_id = unit_type_id
  end
  
  def inspect
    return "Prospect id: #{@id}, agentId: #{@agent_id}, closingTime: #{self.closing_time}, " +
      "initialDate: #{@initial_date}"
  end
end