# 'FileGetter' module for Rentlytics interview
# author: Andrew Ging

module FileGetter
  def self.get_market_rents_file
    filename = 'market_rents.csv'
    filepath = 'd:\Ruby193\src\rentLytics_exercises\\'
    unit_types = {}
    header_read = false
    
    File.open(filepath + filename, 'r').each_line do |line|
      if header_read
        year, month, unit_type_id, previous_market_rent, market_rent = line.split(',')
        yearmonth = year + '-' + ("%02d" % month)
        market_rent.chomp!
        
        if unit_types[unit_type_id].nil?
          new_previous_market_rent = {}
          new_market_rent = {}
          
          new_previous_market_rent[yearmonth] = previous_market_rent        
          new_market_rent[yearmonth] = market_rent
          unit_types[unit_type_id] = UnitType.new(unit_type_id,
            {:previous_market_rent => new_previous_market_rent, :market_rent => new_market_rent})
        else
          unit_types[unit_type_id].add_previous_market_rent(yearmonth, previous_market_rent)
          unit_types[unit_type_id].add_market_rent(yearmonth, market_rent)
        end
      else
        headers = line.split(',')
        headers = headers.map {|head| head.gsub('"', '')}  # remove double-quotes
        headers[4].chomp!
        #h_year = (headers[0] == 'year')      
        unless (headers[0] != 'year' || headers[1] != 'month' || headers[2] != 'unit_type_id' || 
            headers[3] != 'previous_market_rent' || headers[4] != 'market_rent')
          header_read = true
        else
          raise "Header row of file: #{filepath+filename} does not match expected format for a market_rents file"
        end
      end    
    end # file stream closed
    
    return unit_types
  end

  def self.get_prospect_events_file
    filename = 'prospect_events.csv'
    filepath = 'd:\Ruby193\src\rentLytics_exercises\\'
    #agents = {}
    prospects = {}
    header_read = false
    iter = 0
    
    File.open(filepath + filename, 'r').each_line do |line|
      if header_read
        if iter < 20
          # TODO: make it so a string between quotes doesn't get split if it contains a comma:
          prospect = Prospect.process_prospect_row(prospects, line.split(','))
          
          if prospects[prospect.id].nil?
            puts prospect.inspect
            prospects[prospect.id] = prospect
          else
            puts prospect.inspect
            prospects[prospect.id] = prospect
            puts "prospects[prospect.id] = #{prospects[prospect.id].inspect}"
          end  
          #prospect_id, datestamp, event_name, agent_id, source, unit_type_id = 
          #yearmonth = datestamp.scan(/\d{4}-\d{2}/)
          #
        end
      else
        headers = line.split(',')
        headers = headers.map {|head| head.gsub('"', '')}  # remove double-quotes
        headers[5].chomp!
        # TODO: raised error should show which column header failed match
        #h_prospec_id = (headers[0] == 'prospect_id')
        unless (headers[0] != 'prospect_id' || headers[1] != 'datestamp' || headers[2] != 'event_name' || 
            headers[3] != 'agent_id' || headers[4] != 'source' || headers[5] != 'unit_type_id')
          header_read = true
        else
          raise "Header row of file: #{filepath+filename} does not match expected format for a prospect_events file"
        end
      end
      iter += 1
    end
    return prospects
  end
end