-- Leave session
RegisterCommand("leave", function(src)
    PB.Sessions:LeaveSession(src)
end, false)