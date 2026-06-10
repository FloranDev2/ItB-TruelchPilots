--[[

Mark library (version 1.0.0)

]]




--------------------------------------------------- IMPORTATIONS ---------------------------------------------------

--Mod
local mod = mod_loader.mods[modApi.currentMod]

--Paths
local scriptPath = mod.scriptPath
local resourcePath = mod.resourcePath

local markScriptPath = scriptPath .. "/mark/scripts/"
local markResourcePath = scriptPath .. "/mark/"

--Libs
local customAnim = require(markScriptPath.."libs/customAnim")




--------------------------------------------------- VERSION ---------------------------------------------------

local mark = {vers = "1.2.3"}
LOG("TRUELCH PILOTS [A] mark: "..tostring(mark)..", vers: "..mark.vers)

truelch_mark_lib = truelch_mark_lib or { vers = "0.0.0" }
LOG("TRUELCH PILOTS [B] truelch_mark_lib: "..tostring(truelch_mark_lib)..", vers: "..truelch_mark_lib.vers)


function mark:debugMe()
	LOG("vers: "..tostring(mark.vers))
end

--------------------------------------------------- UTILITY / LOCAL FUNCTIONS ---------------------------------------------------

function mark:isGame()
	return true
		and Game ~= nil
		and GAME ~= nil
end

function mark:isMission()
    local mission = GetCurrentMission()

    return true
        and mark:isGame()
        and mission ~= nil
        and mission ~= Mission_Test
end

function mark:missionData()
    local mission = GetCurrentMission()

    --test
    if mission == nil then
    	return nil
    end

    if mission.truelch_mark_lib == nil then
        mission.truelch_mark_lib = {}
    end

    return mission.truelch_mark_lib
end

--------------------------------------------------- INIT ---------------------------------------------------

function mark:realInit()
	truelch_mark_lib = mark

	require(scriptPath.."/mark/scripts/tosx_compat")
	require(scriptPath.."/mark/scripts/assets")
	require(scriptPath.."/mark/scripts/animations")


end

function mark:init()
	--maybe I should use self.vers instead of mark vers --------------------v ?
	if not truelch_mark_lib.vers or modApi:isVersion(truelch_mark_lib.vers, mark.vers) then
		self:realInit()
	end
end

function mark:load()

end



--------------------------------------------------- "PUBLIC" FUNCTIONS ---------------------------------------------------

--p must be a point
function mark:canMark(p)
	--TODO: add assert

	--Additional safety
	if Board:IsTipImage() then
		return false
	end

	local pawn = Board:GetPawn(p)

	--Pawn exists?
	if pawn == nil then
		--LOG("  -> The pawn doesn't exist! -> return false")
		return false
	end

	--Not an enemy?
	if not pawn:IsEnemy() then
		--LOG("  -> This pawn is not an enemy! -> return false")
		return false
	end

	local missionData = self:missionData()

	--Tmp fix for hangar
	if missionData == nil then
		--LOG("missionData is nil!")
		return false
	end

	--Shouldn't be useful anymore
	if missionData.markedPawnIds == nil then
		--LOG("Initialized markedPawnIds (canMark)")
		missionData.markedPawnIds = {} --test
	end

	--TODO: check if it's tip image
	--Already in list?
    for _, v in pairs(missionData.markedPawnIds) do
        if v == pawn:GetId() then
    		--LOG("  -> This enemy is already marked! -> return false")
            return false
        end
    end

	--End
	return true
end


--"local" function (maybe I should add "local" accessor btw?)
function mark:addMark(ret, pawn)
	if pawn == nil then
		return
	end

	local missionData = self:missionData()
	if missionData == nil then
		return
	end

	--Shouldn't be useful anymore
	if missionData.markedPawnIds == nil then
		missionData.markedPawnIds = {}
	end

	table.insert(missionData.markedPawnIds, pawn:GetId())

	local pawnId = pawn:GetId()

	--new: custom animation (to replace my own system with update)
	customAnim:add(pawnId, "truelch_mark_board_c")
end


function mark:removeMark(pawn)
	if pawn == nil then
		--LOG("removeMark -> pawn is nil! -> return!")
		return
	end

	--LOG("removeMark(pawn: " .. pawn:GetType() .. ", id: " .. pawn:GetId() .. ")")

	local missionData = self:missionData()
	if missionData == nil then
		return
	end

	--Shouldn't be useful anymore
	if missionData.markedPawnIds == nil then
		--LOG("Initialized markedPawnIds (removeMark)")
		missionData.markedPawnIds = {} --test
	end

	--Hm I think I can use _ as the index value (might rename it to "i" or "index" actually)
	local index = 0
	for _, v in pairs(missionData.markedPawnIds) do
		if v == pawn:GetId() then
			table.remove(missionData.markedPawnIds, index)
			--LOG("Successfuly found the pawn whose mark must be removed!")
			break
		end
		index = index + 1
	end
	
	--new: custom animation (to replace my own system with update)
	customAnim:rem(pawnId, "truelch_mark_board_c")
end


--Is the public function that's supposed to be called
function mark:markEnemy(ret, spaceDamage, pawn)
	if pawn == nil then
		--LOG("pawn == nil")
		return
	end

	local pawnPos = pawn:GetSpace()
	if not self:canMark(pawnPos) then
		--LOG("can't mark this pawn! -> RETURN!")
		return
	end

	--Show mark
	spaceDamage.sImageMark = "combat/icons/truelch_mark_weapon_mark.png"

	--Mark enemy
	ret:AddScript([[
		local pawn2 = Board:GetPawn(Point(]] .. pawnPos:GetString() .. [[))
		truelch_mark_lib:addMark(ret, pawn2)
	]])

	--tosx compat
	if tifToTosx then
		--LOG("------------------- mark:markEnemy - tifToTosx A")
		ret:AddScript([[
		    local pawn2 = Board:GetPawn(Point(]] .. pawnPos:GetString() .. [[))
		    if GAME.roninMark ~= nil then
		    	GAME.roninMark[pawn2:GetId()] = pawn2:GetId()
		    end
		]])
		--LOG("------------------- mark:markEnemy - tifToTosx B")
	end
end


function mark:isPawnMarked(pawn)
	--TODO: check if the pawn exists, is alive, etc.
	if pawn == nil then
		return
	end

	local missionData = self:missionData()

	if missionData == nil then
		return
	end

	--Shouldn't be useful anymore
	if missionData.markedPawnIds == nil then
		--LOG("Initialized markedPawnIds (isPawnMarked)")
		missionData.markedPawnIds = {} --test
	end

	--There got to be a more efficient way to accomplish this
	--if I use the table as a dictionary and I read directly the value of the key (pawn id)
	for _, v in pairs(missionData.markedPawnIds) do
		if v == pawn:GetId() then
			return true
		end
	end

	--New: tosx Mecha Ronins Hunter mark
	if tosxToTif and not Board:IsTipImage() and GAME and GAME.roninMark ~= nil and GAME.roninMark[Board:GetPawn(pawn:GetSpace()):GetId()] then
		--LOG("Iron fleet detected roninMark!")
		return true
	end

	return false
end

--------------------------------------------------- HOOKS / EVENTS ---------------------------------------------------
--Maybe I can just rely on init on the fly?
local function HOOK_onMissionStart(mission)
	--LOG("HOOK_onMissionStart()")
	--Initialize mark list
	local missionData = truelch_mark_lib:missionData()
	missionData.markedPawnIds = {}
end

local function HOOK_onMissionNextPhaseCreated(prevMission, nextMission)
	--LOG("Left mission " .. prevMission.ID .. ", going into " .. nextMission.ID) --is it also called for regular missions? I don't think so, but...	
	--Initialize mark list
	local missionData = truelch_mark_lib:missionData()	
	missionData.markedPawnIds = {}
end

modApi.events.onTestMechEntered:subscribe(function()
	modApi:runLater(function()
		--Initialize mark list
		local missionData = truelch_mark_lib:missionData()
		missionData.markedPawnIds = {}
	end)
end)


--Weapons that won't have damage bonus against marked enemies. (basically, weapons that use mark for their synergy)
--TODO: move that in the init so that the latest version overwrite it!
mark.excludedWeapons =
{
	"truelch_RotaryCannon",
	"truelch_FighterStrafe",
}

local weapSuffixes = {
	"",
	"_A",
	"_B",
	"_AB"
}

function mark:isExcludedWeapon(weaponId)

	--Another verification: sometimes, weaponId is nil
	if weaponId == nil then
		--LOG("mark:isExcludedWeapon -> weaponId is nil!")
		return true
	end

	--LOG("mark:isExcludedWeapon(weaponId: "..weaponId..")")

	--Table -> string
	if type(weaponId) == 'table' then
		--LOG("type(weaponId) == 'table' verification was useful!")
		weaponId = weaponId.__Id
	end

	for _, exWeapId in pairs(self.excludedWeapons) do
		for _, s in pairs(weapSuffixes) do
			local exWeapId2 = exWeapId..s
			--LOG("mark:isExcludedWeapon -> weaponId: "..weaponId..", exWeapId2: "..exWeapId2)
			if weaponId == exWeapId2 then
				--LOG("mark:isExcludedWeapon -> weaponId == exWeapId2 -> return true")
				return true
			end
		end
	end

	--LOG("mark:isExcludedWeapon -> weaponId == exWeapId2 -> return false")
	return false
end

--Is valid for bonus damage
function mark:isValidForBonusDamage(pawn, spaceDamage, weaponId)
	--LOG("mark:isValidForBonusDamage?")

	--IS NOT TIP IMAGE (!!)
	--Why did I do that?
	if Board:IsTipImage() then
		--LOG("mark:isValidForBonusDamage -> IsTipImage() -> return false")
		return false
	end

	--(ATTACKING) PAWN IS VALID
	if pawn == nil or pawn:IsEnemy() == true then
		--LOG("mark:isValidForBonusDamage -> attacking pawn is nil or is enemy -> return false")
		return false
	end

	--TARGET IS VALID
	local targetPawn = Board:GetPawn(spaceDamage.loc)
	if targetPawn == nil or targetPawn:IsEnemy() == false or not truelch_mark_lib:isPawnMarked(targetPawn) then
		return false
	end

	--DAMAGE MUST BE SUPERIOR TO THRESHOLD
	--Positive for now
	if spaceDamage.iDamage <= 0 then
		--LOG("mark:isValidForBonusDamage -> not an offensive EFFECT (spaceDamage.iDamage: " .. tostring(spaceDamage.iDamage) .. ") -> return false")
		return false
	end

	--NEW: IS EXCLUDED WEAPON?
	if truelch_mark_lib:isExcludedWeapon(weaponId) then
		--LOG("mark:isValidForBonusDamage -> isExcludedWeapon -> return false")
		return false
	end

	--IF EVERYTHING IS OK ---> RETURN TRUE
	return true

end

--IsPassiveSkill("truelch_Mark_Bonus_Damage")
function mark:computeMarkBonusDamage(pawn, skillEffect, weaponId)

	--LOG("TRUELCH PILOTS -> mark:computeMarkBonusDamage")

	if skillEffect == nil or skillEffect.effect == nil then
		return
	end

	for i = 1, skillEffect.effect:size() do
		local spaceDamage = skillEffect.effect:index(i)

		if truelch_mark_lib:isValidForBonusDamage(pawn, spaceDamage, weaponId) then
			local bonusDamage = 1
			if IsPassiveSkill("truelch_Mark_Bonus_Damage") then
				--LOG("IsPassiveSkill(truelch_Mark_Bonus_Damage) -> LETSGOOOO")
				bonusDamage = 2
			end
			--LOG("mark:computeMarkBonusDamage -> bonusDamage: "..tostring(bonusDamage)..", spaceDamage.iDamage: "..tostring(spaceDamage.iDamage))
			spaceDamage.iDamage = spaceDamage.iDamage + bonusDamage --it works!!! thx Lemonymous!
		end

		local targetPawn = Board:GetPawn(spaceDamage.loc)

		--[[
		if CONSUME_MARK and targetPawn ~= nil and truelch_mark_lib:isPawnMarked(targetPawn) then
			truelch_mark_lib:removeMark(targetPawn)
		end
		]]
	end
end

local EVENT_onSkillBuild = function(mission, pawn, weaponId, p1, p2, skillEffect)
	--LOG("TRUELCH PILOTS -> EVENT_onSkillBuild")
	truelch_mark_lib:computeMarkBonusDamage(pawn, skillEffect, weaponId)
end

local EVENT_onFinalEffectBuild = function(mission, pawn, weaponId, p1, p2, p3, skillEffect)
	--LOG("TRUELCH PILOTS -> EVENT_onFinalEffectBuild")
	truelch_mark_lib:computeMarkBonusDamage(pawn, skillEffect, weaponId)
end


local function EVENT_onModsLoaded()

	--TODO: check version
	--LOG(mark:debugMe())
	--truelch_mark_lib:debugMe()
	local isVersion = modApi:isVersion(truelch_mark_lib.vers, mark.vers)
	--LOG("EVENT_onModsLoaded -> TRUELCH PILOTS -> isVersion: "..tostring(isVersion))

	if isVersion then
		--LOG("PILOTS -> EVENT_onModsLoaded -> isVersion")
		modApi:addMissionStartHook(HOOK_onMissionStart)
		modApi:addMissionNextPhaseCreatedHook(HOOK_onMissionNextPhaseCreated)

		modapiext.events.onSkillBuild:subscribe(EVENT_onSkillBuild)
		modapiext.events.onFinalEffectBuild:subscribe(EVENT_onFinalEffectBuild)
	else
		--LOG("PILOTS -> EVENT_onModsLoaded -> NOT isVersion")
	end

end


modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

--------------------------------------------------- RETURN ---------------------------------------------------

return mark