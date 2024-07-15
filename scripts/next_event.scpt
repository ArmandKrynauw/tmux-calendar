set theStartDate to current date
set hours of theStartDate to 0
set minutes of theStartDate to 0
set seconds of theStartDate to 0
set theEndDate to theStartDate + (2 * days) - 1

tell application "Calendar"
  tell calendar "armand.krynauw@labs.epiuse.com"
    set theEvents to every event where its start date is greater than or equal to theStartDate and end date is less than or equal to theEndDate

    repeat with e in theEvents
      properties of e
      -- info of e
      -- set theInfo to event info for event e
      --date string of (get start date of e)
      -- summary of e
    end repeat
  end tell
end tell

