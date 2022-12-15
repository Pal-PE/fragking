-- Leave session
RegisterCommand("leave", function(src)
    PB.Sessions:LeaveSession(src)
    TriggerClientEvent("pb-menu:DisplayMenu", src, true)
end, false)