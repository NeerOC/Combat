require('Common.Shared')

-- Spell ids are sorted with highest to lowest rank.
local SpellID = 
{
}

-- Gets the highest rank known in the array above, gotta sort the ranks ourselves, start with highest.
local Spells = 
{
}

local Auras = 
{
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
	-- Out of combat rotation
end

function DoCombat(player, target)
	-- Combat Rotation
end

RegisterEvent(1, Tick)