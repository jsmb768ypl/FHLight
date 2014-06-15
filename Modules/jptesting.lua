--[[
|cffe5cc80 = beige (artifact)
|cffff8000 = orange (legendary)
|cffa335ee = purple (epic)
|cff0070dd = blue (rare)
|cff1eff00 = green (uncommon)
|cffffffff = white (normal)
|cff9d9d9d = gray (crappy)
|cFFFFff00 = yellow
|cFFFF0000 = red
]]

-----------------------
-- FUNCTION TEST 
-----------------------

local function canCastDebug(spell,unit)
	if spell == "" then return false end
	if unit == nil then unit = "target" end
	local spellname = nil
	if type(spell) == "string" then spellname = spell end
	if type(spell) == "number" then spellname = tostring(select(1,GetSpellInfo(spell))) end
	
	if spellname == nil then print("spell is nil") end
	if jps.PlayerIsBlacklisted(unit) then print("blacklisted unit") end
	if not jps.UnitExists(unit) and not isBattleRez(spellname) then print("invalid unit") end -- isBattleRez need spellname
	
	local usable, nomana = IsUsableSpell(spell) -- usable, nomana = IsUsableSpell("spellName" or spellID)
	if not usable then print("spell is not usable") end
	if nomana then return print("failed mana test") end
	if (jps.cooldown(spellname) > 0) then print("cooldown not finished") end
	if jps.SpellHasRange(spell) and not jps.IsSpellInRange(spell,unit) then print("not in range") end
	if jps[spellname] ~= nil and jps[spellname] == false then print("not spellname") end -- need spellname
	print("passes all tests")
end

local function spelltoName(spellID)
	return tostring(select(1,GetSpellInfo(spellID)))
end

local IsRaidLeader = jps.IsRaidLeader()
local PlayerIsLeader = function()
	if IsInRaid() and IsRaidLeader > 0 then return true end
	if not IsInRaid() and not IsInGroup() then return true end
	return false
end

local GlobalCooldown = function()
	local cdStart, duration = GetSpellCooldown(61304)
	local timeLeft = duration - (GetTime() - cdStart )
	if timeLeft < 0 then timeLeft = 0 end
	return duration
end


function jps_Test()

	jps.LookupEnemy()
	jps.LookupEnemyHealer()

	print("Stun:|cff0070dd ",jps.checkTimer("PlayerStun"))
	print("Interrupt:|cff0070dd ",jps.checkTimer("PlayerInterrupt"))
	print("Shield:|cff0070dd ",jps.checkTimer("ShieldTimer"))
	print("Aggro:|cff0070dd ",jps.FriendAggro("player"))
	print("LoseControl:|cff0070dd ",jps.LoseControl("player"))
	print("ChastiseCd:|cff0070dd ",jps.checkTimer("Chastise"))

-- GetMastery() the value returns by GetMastery is not your final Mastery value
-- To find your true Mastery, and the multiplier factor used to calculate it, see GetMasteryEffect.
--	local mastery = GetMasteryEffect()
--	local masteryValue = math.ceil(mastery)/100
--	local bonusHealing = math.ceil(GetSpellBonusHealing())
--	local minCrit = math.ceil(GetSpellCritChance(2))/100 -- 2 - Holy
--	print("priestFlash",priest.AvgAmountFlashHeal,"/",(1+masteryValue)*(1+minCrit)*(14664+(1.314*bonusHealing)))
--	print("priestGreat",priest.AvgAmountGreatHeal,"/",(1+masteryValue)*(1+minCrit)*(24430+(2.219*bonusHealing)))

--	local friendtableaggro = jps.FriendAggroTable()
--	print("friendtableaggro: ",friendtableaggro)

	write("Isleader: ",PlayerIsLeader())

	--SendChatMessage("Test" , RAID )

end

function jps_RaidTest()

	jps.LookupRaid ()

	local target, dupe, dupecount = jps.LowestTarget()
	print("target: ",target,"count", dupecount,"Table: ", unpack(dupe))
	
	local CountInRange, AvgHealthLoss, FriendUnit = jps.CountInRaidStatus(1)
	write("CountInRange: ",CountInRange,"AvgHealthLoss", AvgHealthLoss,"Table: ", unpack(FriendUnit))

end

-----------------------
-- FUNCTION MEMORY
-----------------------

