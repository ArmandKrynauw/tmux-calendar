require "time"

def parse_time(date_string, time_zone = "Africa/Johannesburg")
  # TODO: Properly parse time zones. Can't believe this is such a shit show in Ruby
  Time.parse("#{date_string} +02:00")
end

def event_description(event)
  title = event[:title]
  separator = '•'
  time = event_relative_time(event)

  "#{title} #{separator} #{time}"
end

def event_relative_time(event)
  event => { start_date:, end_date: }

  if still_upcomming? event
    "in #{relative_time(Time.now, start_date)}"
  elsif halfway_through? event
    "#{relative_time(Time.now, end_date)} left"
  else
    "#{relative_time(start_date, Time.now)} ago"
  end
end

def still_upcomming?(event)
  Time.now < event[:start_date]
end

def halfway_through?(event)
  event => { start_date:, end_date: }
  midpoint = start_date + ((end_date - start_date) / 2.0)
  Time.now > midpoint
end


# TODO: Maybe improve a bit. e.g. 2h instead of 1h 48 min, etc
def relative_time(start_date, end_date)
  time_diff = end_date - start_date
  seconds = time_diff.to_i
  minutes = seconds / 60
  hours = minutes / 60
  days = hours / 24

  segments = []

  if days > 0
    segments << "#{days}d"
  end

  if hours % 24 > 0
    segments << "#{hours % 24}h"
  end

  if minutes % 60 > 0
    segments << "#{minutes % 60}m"
  end

  if segments.empty?
    segments << "#{seconds % 60}s"
  end

  segments.join(' ')
end


