require_relative "utils"

def upcomming_event
  event = upcomming_events.first

  if event
    event_description event
  else
    "No more events today"
  end
end

def upcomming_events
  applescript_path = File.join(__dir__, "upcomming_events.scpt")
  event_data = `osascript #{applescript_path}`.strip
  puts "[DEBUG] event_data: #{event_data}"

  return [] if event_data.empty?

  # All the data is just a comma delimited string
  # Need to figure out how many fields each event has
  fields = event_data.split(',').map(&:strip).map { |e| e.split(':', 2) }
  field_count = fields.map { |f| f.first }.uniq.length
  records = fields.each_slice(field_count)

  [].tap do |events|
    records.each do |event_data|
      event = event_data.to_h.transform_keys(&:to_sym)
      event[:start_date] = parse_time(event[:start_date])
      event[:end_date] = parse_time(event[:end_date])

      events << event
    end
  end
end
