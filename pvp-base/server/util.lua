-- Variables
PB.Utility = {}

-- Trigger client notifcation event
function PB.Utility:Notify(src, _type, string, notify)
    print("tryna notify")
    TriggerClientEvent("pb:Notification", src, _type, string, notify)
end