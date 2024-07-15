use AppleScript version "2.7" -- requires OS X 13.0 or higher
use framework "Foundation"
use framework "EventKit"
use scripting additions

on getAuthorisation()
	display dialog "Access must be given in System Preferences" & linefeed & "-> Security & Privacy first." buttons {"OK"} default button 1

	tell application "System Preferences"
		activate
		tell pane id "com.apple.preference.security" to reveal anchor "Privacy"
	end tell

	error number -128
end getAuthorisation

on fetchStore()
  set theEKEventStore to current application's EKEventStore's new()
  theEKEventStore's requestAccessToEntityType:0 completion:(missing value)

	set authorizationStatus to current application's EKEventStore's authorizationStatusForEntityType:0
	if (authorizationStatus is not 3) then getAuthorisation()

  return theEKEventStore
end fetchStore

on fetchEvents(startDate, endDate)
  set theStore to fetchStore()

	set thePredicate to theStore's predicateForEventsWithStartDate:startDate endDate:endDate calendars:fetchCalendars()
	set theEvents to theStore's eventsMatchingPredicate:thePredicate
  set theEvents to theEvents's sortedArrayUsingSelector:"compareStartDateWithEvent:"

	return theEvents
end fetchEvents

on fetchCalendars()
  fetchStore()'s calendarsForEntityType:0 as list
end fetchCalendars

on fetchCalendarNames()
  set calendarNames to {}

  repeat with calendar in fetchCalendars()
    set calendarName to calendar's title as text
    set end of calendarNames to calendarName
  end repeat

  return calendarNames
end fetchCalendarNames

on fallback(a, b)
  if a is not missing value then
        return a
  else
        return b
  end if
end fallback

on eventInfo(theEvent)
  set info to current application's NSMutableDictionary's new()

  -- Calendar name
  set theCalendar to theEvent's calendar()

  if theCalendar is not missing value then
    set info's |calendar_name| to theCalendar's title()
  end if

  -- Calendar type
  if theCalendar is not missing value then
    set calendarTypes to { "local", "cloud", "exchange", "subscription", "birthday" }
    set theType to theCalendar's type()
    set info's |calendar_type| to item (theType + 1) of calendarTypes
  end if

  -- ID
  -- set info's |id| to fallback(theEvent's ID(), "")

  -- External ID
  set info's |external_id| to fallback(theEvent's calendarItemExternalIdentifier(), "")

  -- Title
  set info's |title| to fallback(theEvent's title(), "")

  -- Description
	if theEvent's hasNotes() then
    set info's |description| to fallback(theEvent's notes(), "")
	end if

  -- Start date
  set startDate to theEvent's startDate() as date
  set startDateString to short date string of startDate -- YYYY/MM/DD
  set startTimeString to time string of startDate -- HH:MM:SS
  set info's |start_date| to (startDateString & " " & startTimeString)

  -- End date
  set endDate to theEvent's endDate() as date
  set endDateString to short date string of endDate -- YYYY/MM/DD
  set endTimeString to time string of endDate -- HH:MM:SS
  set info's |end_date| to endDateString & " " & endTimeString

  -- All day
  set info's |all_day| to theEvent's isAllDay()

  -- Time zone
  set timeZone to theEvent's timeZone()
  if timeZone is not missing value then
    set info's |time_zone| to timeZone's |name|()
  end if

  -- Location
  set info's |location| to fallback(theEvent's location(), "")

	return info as record
end eventInfo

