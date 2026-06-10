--Mod
local mod = mod_loader.mods[modApi.currentMod]

--Paths
local scriptPath = mod.scriptPath
local resourcePath = mod.resourcePath

local markScriptPath = scriptPath .. "/mark/scripts/"
local markResourcePath = scriptPath .. "/mark/"


--Mark icons (weapon's mark)
modApi:appendAsset("img/combat/icons/truelch_mark_weapon_mark.png", markResourcePath.."img/combat/icons/truelch_mark_weapon_mark.png")
	Location["combat/icons/truelch_mark_weapon_mark.png"] = Point(-21, 4)

--Mark icons (board)
for i = 0, 2 do
	--big red (b)
	modApi:appendAsset("img/combat/icons/truelch_mark_board_b_"..tostring(i)..".png", markResourcePath.."img/combat/icons/truelch_mark_board_b_0.png")
		Location["combat/icons/truelch_mark_board_b_"..tostring(i)..".png"] = Point(-15, 6)
	--small red (c)
	modApi:appendAsset("img/combat/icons/truelch_mark_board_c_"..tostring(i)..".png", markResourcePath.."img/combat/icons/truelch_mark_board_c_"..tostring(i)..".png")
		Location["combat/icons/truelch_mark_board_c_"..tostring(i)..".png"] = Point(-15, 6)
	--big yellow (tmp b)
	modApi:appendAsset("img/combat/icons/truelch_mark_board_b_"..tostring(i)..".png", markResourcePath.."img/combat/icons/truelch_mark_board_b_"..tostring(i)..".png")
		Location["combat/icons/truelch_mark_board_b_"..tostring(i)..".png"] = Point(-15, 6)
	--small yellow (tmp c)
	modApi:appendAsset("img/combat/icons/truelch_mark_board_c_"..tostring(i)..".png", markResourcePath.."img/combat/icons/truelch_mark_board_c_"..tostring(i)..".png")
		Location["combat/icons/truelch_mark_board_c_"..tostring(i)..".png"] = Point(-15, 6)
end

--small red (c) - "real" anim for custom tip images
modApi:appendAsset("img/combat/icons/truelch_mark_board_c.png", markResourcePath.."img/combat/icons/truelch_mark_board_c.png")
	Location["combat/icons/truelch_mark_board_c.png"] = Point(-15, 6)