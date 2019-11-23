require('Common.Shared')

-- Spell ids are sorted with highest to lowest rank.
local SpellID = 
{
	SinisterStrike = {1752, 1757, 1758, 1759, 1760, 8621, 8406, 11293, 11294},
	SliceAndDice = {5171, 6774},
	Eviscerate = {2098, 6760, 6761, 6762, 8623, 8624, 11299, 11300, 31016},
	Stealth = {1784, 1785, 1786, 1787},
	Vanish = {1856, 1857, 27617},
	Vanish_Aura = {11327, 11329}
}

-- Gets the highest rank known in the array above, gotta sort the ranks ourselves, start with highest.
local Spells = 
{
	SinisterStrike = getBestSpell(SpellID.SinisterStrike),
	SliceAndDice = getBestSpell(SpellID.SliceAndDice),
	Eviscerate = getBestSpell(SpellID.Eviscerate)
}

local Auras = 
{
	Stealth = getHighestAura(SpellID.Stealth),
	SliceAndDice = getHighestAura(SpellID.SliceAndDice),
	--Vanish_Aura = getHighestAura(SpellID.Vanish_Aura)
}

function Tick(event, player)
	local target = player:GetTarget()
	
	if not ShouldAttack(player, target) then
		return
	end

	DoCombat(player, target)
end


function DoCombat(player, target)
	if player:HasAura(Auras.Stealth) then
		return
	end
	
	local snd = player:HasAura(Auras.SliceAndDice)
	--local sndAura = player:GetAuraByPlayer(AURA_SLICE_AND_DICE) --TODO REVISIT ME FOR TIMING THE AURA when ther's not much left

	if not snd and player:GetComboPoints() > 1 and Spells.SliceAndDice:CanCast() then
		Spells.SliceAndDice:Cast(target)
		return
	end
	
	
	if player:GetEnergy() > 60 then
		--if #player:GetNearbyEnemyUnits(12) > 1 and SPELL_BLADE_FLURRY:CanCast(player) then
		--	SPELL_BLADE_FLURRY:Cast(player)
		--	return
		--end
		
		if player:GetComboPoints() > 3 and Spells.Eviscerate:CanCast(target) then
			Spells.Eviscerate:Cast(target)
			return
		end
	
		if Spells.SinisterStrike:CanCast(target) then
			Spells.SinisterStrike:Cast(target)
			return
		end
	end
	
end

RegisterEvent(1, Tick)