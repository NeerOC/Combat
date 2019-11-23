local wandTime

function ShouldAttack(player, target)
	if player:IsMounted() or
		not target or
		(not player:InCombat() and not target:InCombat()) or
		target:IsDead() or
		target:IsFriendlyWithPlayer() or
		not player:IsFacing(target:GetPosition()) or
		player:IsCasting() or
		player:IsChanneling() or
		player:HasTerrainSpellActive() then
		return false
	end

	return true
end

function ShouldAttackSpecial(player, target)
	if player:IsMounted() or
		not target or
		(not player:InCombat() and not target:InCombat()) or
		target:IsDead() or
		target:IsFriendlyWithPlayer() or
		not player:IsFacing(target:GetPosition()) or
		player:IsCasting() or
		player:HasTerrainSpellActive() then
		return false
	end

	return true
end

function AbleTo(player)
	return not IsDead(player) and not player:IsMounted()
end

-- Sort table function
function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-- returns amount of debuffs around you (Good for sheep where you can only sheep one)
function getDebuffCount(player, debuff)
	local Units = player:GetNearbyEnemyUnits(50)
	local count = 0

	for i = 1, #Units do
		if Units[i]:HasAuraByPlayer(debuff) then
			count = count + 1
		end
	end

	return count
end

-- Gets nearby enemies that are facing and targetting us.
function getNearbyEnemies(player, yrd)
	local Enemies = player:GetNearbyEnemyUnits(yrd)
	local EnemyTable = {}
	local myPet = player:GetPet()
	local pGUID = player:GetGUID():GetLoWord()
	if myPet then local petGUID = myPet:GetGUID():GetLoWord() end

	for i = 1, #Enemies do
		if Enemies[i]:GetTarget() then	
			local enemyTarget = Enemies[i]:GetTarget():GetGUID():GetLoWord()
			local currentEnemy = Enemies[i]
			
			if currentEnemy:InCombat() and (enemyTarget == pGUID and currentEnemy:IsFacing(player) or myPet and enemyTarget == petGUID and currentEnemy:IsFacing(myPet)) then
				table.insert(EnemyTable, currentEnemy)
			end
		end
	end

	return EnemyTable
end

function getBestSpell(arr)
	for i = 1, #arr do
		local fauxSpell = Spell(arr[i])
		if fauxSpell:IsKnown() then
			return fauxSpell
		end
	end
end

function getHighestAura(arr)
	for i = 1, #arr do
		local fauxSpell = Spell(arr[i])
		if fauxSpell:IsKnown() then
			-- We return the ID and then the position in the array.
			return arr[i], i
		end
	end
end

function shouldBuff(player, AuraList)
	local myBest, arrPos = getHighestAura(AuraList)

	if myBest then
		for i = 1, #AuraList do
			local Aura = player:GetAura(AuraList[i])
			if Aura and (i < arrPos or Aura:GetSpellID() == myBest) then
				return false
			end
		end
	end

	return true
end

function hasBuff(player, AuraID)
	local theBuff = player:GetAura(AuraID)
	if theBuff then
		local timeLeft = theBuff:GetTimeleft()
		return true, timeLeft
	end

	return false
end

function Wand(player, target)
	local Wand = Spell(5019)

	if not player:IsCasting() and (not wandTime or GetCurTimeMs() - wandTime > 750) then
		if Wand:CanCast(target) and Wand:IsReady() then
			wandTime = GetCurTimeMs()
			Wand:Cast(target)
			return
		end
	end
end

function IsDead(player)
	return hasBuff(player, 8326)
end