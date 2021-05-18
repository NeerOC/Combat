require('Common.Shared')

-- Spell ids are sorted with highest to lowest rank.
local SpellID = 
{
	Frostbolt = {25304, 10181, 10180, 10179, 8408, 8407, 8406, 7322, 837, 205, 116},
	FireBlast = {10199, 10197, 8413, 8412, 2138, 2137, 2136},
	ConeOfCold = {10161, 10160, 10159, 8492, 120},
	FrostArmor = {7301, 7300, 168},
	IceArmor = {10220, 10219, 7320, 7302},
	MageArmor = {22783, 22782, 6117},
	FrostWard = {28609, 10177, 8462, 8461, 6143},
	FireWard = {10225, 10223, 8458, 8457, 543},
	DampenMagic = {10174, 10173, 8451, 8450, 604},
	ArcaneIntellect = {10157, 10156, 1461, 1460, 1459},
	Counterspell = {2139},
	MageShield = {10193, 10192, 10191, 8495, 8494, 1463},
	Polymorph = {28271, 28272, 12826, 12825, 12824, 118}
	
}

-- Gets the highest rank known in the array above, gotta sort the ranks ourselves, start with highest.
local Spells = 
{
	Frostbolt = getBestSpell(SpellID.Frostbolt),
	FireBlast = getBestSpell(SpellID.FireBlast),
	ConeOfCold = GetBestSpell(SpellID.ConeOfCold),
	FrostArmor = getBestSpell(SpellID.FrostArmor),
	IceArmor = getBestSpell(SpellID.IceArmor),
	MageArmor = GetBestSpell(SpellID.MageArmor),
	FrostWard = GetBestSpell(SpellID.FrostWard),
	FireWard = GetBestSpell(SpellID.FireWard),
	DampenMagic = GetBestSpell(SpellID.DampenMagic),
	ArcaneIntellect = getBestSpell(SpellID.ArcaneIntellect),
	Counterspell = GetBestSpell(SpellID.Counterspell),
	MageShield = GetBestSpell(SpellID.MageShield),
	Polymorph = getBestSpell(SpellID.Polymorph)
}

local Auras = 
{
	Polymorph = getHighestAura(SpellID.Polymorph)
}

function Tick(event, player)
	local target = player:GetTarget()
	
	if not AbleTo(player) then 
		return
	end

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

	if Spells.ArcaneIntellect:CanCast(player) and shouldBuff(player, SpellID.ArcaneIntellect) then
		Spells.ArcaneIntellect:Cast(player)
		return
	end
end

function DoCombat(player, target)
	local currentMana = player:GetManaPercent()
	local currentHP = player:GetHealthPercent()
	local Enemies = getNearbyEnemies(player, 30)
	
	-- Wand is global :) Let's Wand em below 15% mana.
	if currentMana < 15 then
		Wand(player, target)
		return
	end

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
