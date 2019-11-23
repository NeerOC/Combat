require('Common.Shared')

-- Spell ids are sorted with highest to lowest rank.
local SpellID = 
{
	Frostbolt = {25304, 10181, 10180, 10179, 8408, 8407, 8406, 7322, 837, 205, 116},
	FireBlast = {10199, 10197, 8413, 8412, 2138, 2137, 2136},
	FrostArmor = {7301, 7300, 168},
	IceArmor = {10220, 10219, 7320, 7302}
}

-- Gets the highest rank known in the array above, gotta sort the ranks ourselves, start with highest.
local Spells = 
{
	Frostbolt = getBestSpell(SpellID.Frostbolt),
	FireBlast = getBestSpell(SpellID.FireBlast),
	FrostArmor = getBestSpell(SpellID.FrostArmor),
	IceArmor = getBestSpell(SpellID.IceArmor)
}

function Tick(event, player)
	local target = player:GetTarget()
	DoPreCombat(player)

	if not ShouldAttack(player, target) then
		return
	end

	DoCombat(player, target)
end

function DoPreCombat(player)
	-- If we dont have Ice Armor then we should go with frost armor.
	if not Spells.IceArmor then
		if Spells.FrostArmor:CanCast(player) and shouldBuff(player, SpellID.FrostArmor) then
			Spells.FrostArmor:Cast(player)
			return
		end
	end
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