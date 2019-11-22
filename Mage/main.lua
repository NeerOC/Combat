require('Common.Shared')

-- Spell ids are sorted with highest to lowest rank.
local SpellID = 
{
	Frostbolt = {25304, 10181, 10180, 10179, 8408, 8407, 8406, 7322, 837, 205, 116},
	FireBlast = {10199, 10197, 8413, 8412, 2138, 2137, 2136},
}

-- Gets the highest rank known in the array above, gotta sort the ranks ourselves, start with highest.
local Spells = 
{
	Frostbolt = getHighestSkill(SpellID.Frostbolt),
	FireBlast = getHighestSkill(SpellID.FireBlast)
}

function Tick(event, player)
	local target = player:GetTarget()
	
	if not ShouldAttack(player, target) then
		return
	end

	DoCombat(player, target)
end

function DoCombat(player, target)
	if Spells.FireBlast:CanCast(target) then
		Spells.FireBlast:Cast(target)
		return
	end

	if Spells.Frostbolt:CanCast(target) then
		Spells.Frostbolt:Cast(target)
		return
	end
end

RegisterEvent(1, Tick)