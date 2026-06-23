local this = {}

local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath
local pilotSkill_tooltip = mod.libs.pilotSkill_tooltip



local pilot = {
	Id = "Pilot_Revenge_Mark",
	Personality = "Revenge_Mark",
	Name = "Revenge Mark",
	Sex = SEX_MALE, --or other sex
	Skill = "Skill_Revenge_Mark",
	Voice = "/voice/kwan", --or other voice
}

--[[
Helper function to see if the board currently has this pilots ability
--]]
local function BoardHasAbility()
	for id = 0, 2 do
		if Board:GetPawn(id):IsAbility(pilot.Skill) then
			return true
		end
	end
end

local function isGame()
	return true
		and Game ~= nil
		and GAME ~= nil
end

local function isMission()
	local mission = GetCurrentMission()

	return true
		and isGame()
		and mission ~= nil
		and mission ~= Mission_Test
end

function this:GetPilot()
	return pilot
end

function this:init(mod)
	CreatePilot(pilot)
	pilotSkill_tooltip.Add(pilot.Skill, PilotSkill("Revenge Mark", "Mark any enemy that damaged an ally or a building."))
end

local lastEnemy

local EVENT_onPawnDamaged = function(mission, pawn, damageTaken)
	--LOG(pawn:GetMechName().." has taken "..damageTaken.." damage!")

	--if Board:GetPawn(pawn:GetId()):IsAbility(pilot.Skill) and lastEnemy ~= nil then --only when the pilot is attack
	if isMission() and BoardHasAbility() and not pawn:IsEnemy() and lastEnemy ~= nil then --for any ally
		--LOG("----------------> HERE!")
		local se = SkillEffect()
		local damage = SpaceDamage(lastEnemy:GetSpace(), 0)
		truelch_mark_lib:markEnemy(se, damage, lastEnemy)
		se:AddDamage(damage)
		Board:AddEffect(se)
	end
end

local EVENT_onBuildingDamaged = function(point, damageTaken)
	--LOG("EVENT_onBuildingDamaged -> Building at: "..point:GetString().." took: "..tostring(damageTaken).." damage!")

	if lastEnemy ~= nil and BoardHasAbility() then
		--LOG("----------------> HERE!")
		local se = SkillEffect()
		local damage = SpaceDamage(lastEnemy:GetSpace(), 0)
		truelch_mark_lib:markEnemy(se, damage, lastEnemy)
		se:AddDamage(damage)
		Board:AddEffect(se)
	end
end

--TODO: clear lastEnemy when enemy turn is over / player turn starts. (also be aware of ENV damage)
--Problem is that p2 is kinda arbitrary (multiple tiles attacks)
local EVENT_onQueuedSkillStart = function(mission, pawn, weaponId, p1, p2)
	lastEnemy = pawn
end

local EVENT_onNextTurn = function(mission)
	if Game:GetTeamTurn() == TEAM_PLAYER then
		lastEnemy = nil
	end
end

modapiext.board.events.onBuildingDamaged:subscribe(EVENT_onBuildingDamaged)
modapiext.events.onQueuedSkillStart:subscribe(EVENT_onQueuedSkillStart)
modapiext.events.onPawnDamaged:subscribe(EVENT_onPawnDamaged)
modApi.events.onNextTurn:subscribe(EVENT_onNextTurn)

return this