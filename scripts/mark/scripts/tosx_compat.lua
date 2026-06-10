--------------------------------------------------- TOSX ---------------------------------------------------
local mod = mod_loader.mods[modApi.currentMod]


--Mod options
modApi:addGenerationOption("option_mark_tif_to_tosx",
	"Iron Fleet -> tosx",
	"Should the Iron Fleet marking affect tosx' Mecha Ronin Hunter?",
	{enabled = true}
)

modApi:addGenerationOption("option_mark_tosx_to_tif",
	"tosx -> Iron Fleet",
	"Should tosx' Mecha Ronin Hunter marking affect the Iron Fleet?",
	{enabled = true}
)

--[[local]] tifToTosx = true
--[[local]] tosxToTif = true
modApi.events.onModLoaded:subscribe(function(id)
	if id ~= mod.id then return end
	local options = mod_loader.currentModContent[id].options
	--[[
	tifToTosx = options["option_mark_tif_to_tosx"].enabled
	tosxToTif = options["option_mark_tosx_to_tif"].enabled
	]]
	--LOG("---------------- tifToTosx: " .. tostring(tifToTosx) .. ", type: " .. tostring(type(tifToTosx)))
	--LOG("---------------- tosxToTif: " .. tostring(tosxToTif) .. ", type: " .. tostring(type(tosxToTif)))
end)