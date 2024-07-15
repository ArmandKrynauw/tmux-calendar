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

