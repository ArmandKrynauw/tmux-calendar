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

