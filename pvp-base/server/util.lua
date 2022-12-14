-- Variables
PB.Utility = {}

-- Trigger client notifcation event
function PB.Utility:Notify(src, _type, string, notify)
    TriggerClientEvent("pb:Notification", src, _type, string, notify)
end