local PB = exports["pvp-base"]:GetCoreObject()

RegisterNetEvent("raid_clothes:save", function(data)
	local src = source
	local ply = PB.Accounts:Get(src)
	if not ply then return false end
	exports.oxmysql:query("UPDATE pb_players SET `skin` = ?WHERE identifier = ?",
	{json.encode(data), ply.identifier})
end)

RegisterNetEvent("raid_clothes:getPlayerSkin", function()
	local src = source
	local ply = PB.Accounts:Get(src)
	if not ply then return false end
	exports.oxmysql:query("SELECT * FROM pb_players WHERE identifier = ?", 
	{ply.identifier}, function(result)
		if result[1] then
			print(result[1].skin)
			if result[1].skin then
				skin = json.decode(result[1].skin)
				TriggerClientEvent("raid_clothes:getPlayerSkinCB", src, skin)
				TriggerClientEvent("pb-menu:DisplayMenu", src, true)
			else
				TriggerClientEvent("pb-menu:CreateNewChar", src)
			end
		end
	end)
end)
