require('Common.Shared')

-- Spell ids are sorted with highest to lowest rank.
local SpellID = 
{
	GreaterHeal = {25314,10965,10964,10963,2060},
	Renew = {25315,10929,10928,10927,6078,6077,6076,6075,6074,139}
}

-- Gets the highest rank known in the array above, gotta sort the ranks ourselves, start with highest.
local Spells = 
{
	GreaterHeal = getBestSpell(SpellID.GreaterHeal),
	Renew = getBestSpell(SpellID.Renew)
}

local Auras = 
{
	Renew = getHighestAura(SpellID.Renew)
}

function Tick(event, player)
	local target = player:GetTarget()
	
	if not AbleTo(player) then 
		return
	end

	local lowestPartyMember = getLowestPartyMember(player)
	
	
			

	if lowestPartyMember ~= nil then
	
		local lowestPartyMemberHasRenew = lowestPartyMember:GetAuraByPlayer(Auras.Renew)
				
		if lowestPartyMemberHasRenew == nil and lowestPartyMember:GetHealthPercent() < 75 and Spells.Renew:CanCast(lowestPartyMember) then
			Spells.Renew:Cast(lowestPartyMember)
			return
		end
	
		if lowestPartyMember:GetHealthPercent() < 80 and Spells.GreaterHeal:CanCast(lowestPartyMember) then
			Spells.GreaterHeal:Cast(lowestPartyMember)
			return
		end 

	end

	--DoPreCombat(player)

	--if not ShouldAttack(player, target) then
	--	return
	--end

	--DoCombat(player, target)
end

function DoPreCombat(player)
	-- Out of combat rotation
	-- Combat Rotation
	
end

function DoCombat(player, target)
	-- Combat Rotation
--	local lowestPartyMember = getLowestPartyMember(player)
--	if lowestPartyMember:GetHealthPercent() <90 and Spells.GreaterHeal:CanCast(lowestPartyMember) then
--		Spells.GreaterHeal:Cast(lowestPartyMember)
--		return
	--end
end

RegisterEvent(1, Tick)