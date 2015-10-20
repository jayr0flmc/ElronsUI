-- Dependencies
local Engine = getglobal('ElronsUI')
local Layout = Engine:GetModule('Layout')
local UnitFrames = Engine:GetModule('UnitFrames')
local DB

-- Register new module

-- Register variables

-- External functions

-- Internal functions



-- Class functions
function UnitFrames:TargetFrame_UpdateName()
	local frame = getglobal('ElronsUI_UnitFrame_Target_HealthBar').info.center
	local unitName, unitClass, unitColor
	local DB = Engine.DB.db.profile.general.class
	
	if(UnitExists('target')) then
		unitName	= UnitName('target')
		unitClass	= UnitClass('target')
		unitColor	= {r = 1.0, g = 1.0, b = 1.0}
		if(unitClass) then unitColor = DB[strlower(unitClass)].color end
		if(UnitPVPRank('target') >= 5) then unitName = UnitPVPName('target') end
		
		frame:SetTextColor(unitColor.r, unitColor.g, unitColor.b)
		frame:SetText(unitName)
	end
end

function UnitFrames:TargetFrame_UpdateLevel()
	local frame = getglobal('ElronsUI_UnitFrame_Target_HealthBar')
	local level, color
	
	level = UnitLevel('target')
	
	if(UnitIsCorpse('target')) then
		frame.info.PlayerLevel:Hide()
	elseif(level > 0) then
		-- Normal level target
		frame.info.PlayerLevel:SetText(level)
		
		-- Color level number
		if(UnitCanAttack('player', 'target')) then
			color = GetDifficultyColor(level)
			
			frame.info.PlayerLevel:SetTextColor(color.r, color.g, color.b)
		else
			frame.info.PlayerLevel:SetTextColor(1.0, 0.82, 0.0)
		end
		
		frame.info.PlayerLevel:Show()
	else
		-- Target is too high level to tell
		frame.info.PlayerLevel:SetText('??')
		frame.info.PlayerLevel:SetTextColor(1.0, 0.0, 0.0)
	end
end

function UnitFrames:TargetFrame_UpdateClass()
	local frame = getglobal('ElronsUI_UnitFrame_Target_HealthBar')
	local unitClass = UnitClass('target')
	if(not unitClass) then unitClass = 'none' end
	if(not UnitIsPlayer('target')) then unitClass = 'none' end
	
	self:SetClassIconTexture(frame.info.PlayerClass, unitClass)
end

function UnitFrames:TargetFrame_UpdatePvP()
	local frame			= getglobal('ElronsUI_UnitFrame_Target_HealthBar')
	local rankFrame		= frame.info.PlayerRank
	local factionFrame	= frame.info.PlayerFaction
	local pvpRank		= UnitPVPRank('target')
	local factionGroup, factionName = UnitFactionGroup('target')
	
	if(pvpRank >= 5) then
		pvpRank = pvpRank - 4
		
		if(pvpRank < 10) then rankFrame:SetTexture('Interface\\PvPRankBadges\\PvPRank0'..pvpRank) end
		if(pvpRank >= 10) then rankFrame:SetTexture('Interface\\PvPRankBadges\\PvPRank'..pvpRank) end
		
		rankFrame:Show()
	else
		rankFrame:Hide()
	end
	
	if(UnitIsPVPFreeForAll('target')) then
		PlaySound('igPVPUpdate')
		factionFrame:SetTexture('Interface\\TargetingFrame\\UI-PVP-FFA')
		factionFrame:Show()
	elseif(factionGroup and UnitIsPVP('target')) then
		PlaySound('igPVPUpdate')
		factionFrame:SetTexture('Interface\\TargetingFrame\\UI-PVP-'..factionGroup)
		if(factionGroup == 'Horde') then
			factionFrame:SetPoint('TOP', frame, 'TOP', 15, -1)
		elseif(factionGroup == 'Alliance') then
			factionFrame:SetPoint('TOP', frame, 'TOP', 15, -2)
		end
		factionFrame:Show()
	else
		factionFrame:Hide()
	end
end

function UnitFrames:TargetFrame_UpdateHealth()
	local valCur, valMax, valPer
	local cVal, mVal
	local bar = getglobal('ElronsUI_UnitFrame_Target_HealthBar')
	local left = bar.info.left
	local right = bar.info.right
	local color, alpha
	
	if(UnitExists('target')) then
		valCur	= UnitHealth('target')
		valMax	= UnitHealthMax('target')
		
		if(valMax > 100) then
			valPer = (valCur / valMax) * 100
			if(strlen(valCur) > 4) then
				cVal = strsub(valCur, 1, strlen(valCur) - 3)
				cVal = cVal..'.'..strsub(valCur, strlen(cVal), 2)..'k'
			else
				cVal = valCur
			end
			if(strlen(valMax) > 4) then
				mVal = strsub(valMax, 1, strlen(valMax) - 3)
				mVal = mVal..'.'..strsub(valMax, strlen(mVal), 2)..'k'
			else
				mVal = valMax
			end
			
			left:SetText(tonumber(string.format('%.2f', valPer))..' %')
			right:SetText(cVal..'/'..mVal)
		else
			valPer = valCur
			
			left:SetText(tonumber(string.format('%.2f', valPer))..' %')
			right:SetText('')
		end
		
		color = {r = 0.0, g = 1.0, b = 0.0}
		alpha = {bg = 0.15, bar = 0.5}
		
		if(valPer > 95) then
			color.r = 0.1
		elseif(valPer > 90) then
			color.r = 0.2
		elseif(valPer > 85) then
			color.r = 0.3
		elseif(valPer > 80) then
			color.r = 0.4
		elseif(valPer > 75) then
			color.r = 0.5
		elseif(valPer > 70) then
			color.r = 0.6
		elseif(valPer > 65) then
			color.r = 0.7
		elseif(valPer > 60) then
			color.r = 0.8
		elseif(valPer > 55) then
			color.r = 0.9
		elseif(valPer > 50) then
			color.r = 1.0
		elseif(valPer > 45) then
			color.r = 1.0
			color.g = 0.9
		elseif(valPer > 40) then
			color.r = 1.0
			color.g = 0.8
		elseif(valPer > 35) then
			color.r = 1.0
			color.g = 0.7
		elseif(valPer > 30) then
			color.r = 1.0
			color.g = 0.6
		elseif(valPer > 25) then
			color.r = 1.0
			color.g = 0.5
		elseif(valPer > 25) then
			color.r = 1.0
			color.g = 0.4
		elseif(valPer > 25) then
			color.r = 1.0
			color.g = 0.3
		elseif(valPer > 25) then
			color.r = 1.0
			color.g = 0.2
		elseif(valPer > 25) then
			color.r = 1.0
			color.g = 0.1
		elseif(valPer > 0) then
			color.r = 1.0
			color.g = 0.0
		end
		
		bar:SetMinMaxValues(0, valMax)
		bar:SetValue(valCur)
		bar:SetBackdropColor(color.r, color.g, color.b, alpha.bg)
		bar:SetStatusBarColor(color.r, color.g, color.b, alpha.bar)
	end
end

function UnitFrames:TargetFrame_UpdateMana()
	local valCur, valMax, valPer
	local cVal, mVal
	local bar = getglobal('ElronsUI_UnitFrame_Target_ManaBar')
	local left = bar.info.left
	local right = bar.info.right
	local isPlayer, class, color, alpha, powerType
	
	if(UnitExists('target')) then
		valCur		= UnitMana('target')
		valMax		= UnitManaMax('target')
		valPer		= (valCur / valMax) * 100
		isPlayer	= UnitIsPlayer('target')
		class		= UnitClass('target')
		
		if(strlen(valCur) > 4) then
			cVal = strsub(valCur, 1, strlen(valCur) - 3)
			cVal = cVal..'.'..strsub(valCur, strlen(cVal), 2)..'k'
		else
			cVal = valCur
		end
		if(strlen(valMax) > 4) then
			mVal = strsub(valMax, 1, strlen(valMax) - 3)
			mVal = mVal..'.'..strsub(valMax, strlen(mVal), 2)..'k'
		else
			mVal = valMax
		end
		
		color = {r = 0.0, g = 0.0, b = 0.0}
		alpha = {bg = 0.15, bar = 0.5}
		powerType = UnitPowerType('target')
		left:SetText('')
		right:SetText('')
		
		if(isPlayer) then
			if(powerType == 0) then
				-- Mana
				color.b = 1.0
			elseif(powerType == 1) then
				-- Rage
				color.r = 1.0
			elseif(powerType == 2) then
				-- Focus
				color.r = 1.0
				color.g = 0.5
				color.b = 0.25
			elseif(powerType == 3) then
				-- Energy
				color.r = 1.0
				color.g = 1.0
			elseif(powerType == 4) then
				-- Happiness
				color.r = 0.0
				color.g = 1.0
				color.b = 1.0
			end
			
			left:SetText(tonumber(string.format('%.2f', valPer))..' %')
			right:SetText(cVal..'/'..mVal)
		else
			if(valMax > 0) then
				if(powerType == 0) then
					-- Mana
					color.b = 1.0
				elseif(powerType == 1) then
					-- Rage
					color.r = 1.0
				elseif(powerType == 2) then
					-- Focus
					color.r = 1.0
					color.g = 0.5
					color.b = 0.25
				elseif(powerType == 3) then
					-- Energy
					color.r = 1.0
					color.g = 1.0
				elseif(powerType == 4) then
					-- Happiness
					color.r = 0.0
					color.g = 1.0
					color.b = 1.0
				end
				
				left:SetText(tonumber(string.format('%.2f', valPer))..' %')
				right:SetText(cVal..'/'..mVal)
			end
		end
		
		bar:SetMinMaxValues(0, valMax)
		bar:SetValue(valCur)
		bar:SetBackdropColor(color.r, color.g, color.b, alpha.bg)
		bar:SetStatusBarColor(color.r, color.g, color.b, alpha.bar)
	end
end

function UnitFrames:TargetFrame_UpdateGroup()
	local frame				= getglobal('ElronsUI_UnitFrame_Target_HealthBar')
	local iconLeader		= frame.info.LeaderIcon
	local iconMasterLooter	= frame.info.LootIcon
	local iconRaidMark		= frame.info.RaidIcon
	local index				= GetRaidTargetIndex('target')
	local inParty			= UnitInParty('target')
	local inRaid			= UnitInRaid('target')
	
	if(index) then
		SetRaidTargetIconTexture(iconRaidMark, index)
		iconRaidMark:Show()
	else
		SetRaidTargetIconTexture(iconRaidMark, 0)
		iconRaidMark:Hide()
	end
	
	if(inParty or inRaid) then
		local method, master = GetLootMethod()
		
		if(UnitIsPartyLeader('target')) then iconLeader:Show() else iconLeader:Hide() end
	else
		iconLeader:Hide()
		iconMasterLooter:Hide()
	end
end

function UnitFrames:TargetFrame_UpdateBuffs()
	local button, texture, count
	local fsCount, fsCooldown
	local DB = Engine.DB.db.profile.unitframe
	
	for i = 1, DB.target.buffs.max do
		button		= getglobal('ElronsUI_UnitFrame_Target_BuffBar_Button'..i)
		fsCount		= button.count
		fsCooldown	= button.cooldown
		texture, count = UnitBuff('target', i)
		
		if(texture) then
			button:SetNormalTexture(texture)
			
			if(count > 1) then
				fsCount:SetText(tostring(count))
				fsCount:Show()
			else
				fsCount:SetText('')
				fsCount:Hide()
			end
			
			button:Show()
		else
			button:Hide()
		end
	end
end
function UnitFrames:TargetFrame_UpdateDebuffs()
	local button, texture, count
	local fsCount, fsCooldown
	local DB = Engine.DB.db.profile.unitframe
	
	for i = 1, DB.target.debuffs.max do
		button		= getglobal('ElronsUI_UnitFrame_Target_DebuffBar_Button'..i)
		fsCount		= button.count
		fsCooldown	= button.cooldown
		texture, count = UnitDebuff('target', i)
		
		if(texture) then
			button:SetNormalTexture(texture)
			
			if(count > 1) then
				fsCount:SetText(tostring(count))
				fsCount:Show()
			else
				fsCount:SetText('')
				fsCount:Hide()
			end
			
			button:Show()
		else
			button:Hide()
		end
	end
end

function UnitFrames:TargetFrame_UpdateTrivial()
	local bar = getglobal('ElronsUI_UnitFrame_Target_HealthBar')
	
	if(UnitIsTrivial('target')) then
		bar:SetBackdropColor(0.5, 0.5, 0.5, 0.15)
		bar:SetStatusBarColor(0.5, 0.5, 0.5, 0.5)
	end
end

function UnitFrames:TargetFrame_UpdateLayout()
end
function UnitFrames:TargetFrame_Update()
	local frame = getglobal('ElronsUI_UnitFrame_Target')
	
	if(UnitExists('target')) then
		self:TargetFrame_UpdateName()
		self:TargetFrame_UpdateLevel()
		self:TargetFrame_UpdateClass()
		self:TargetFrame_UpdatePvP()
		self:TargetFrame_UpdateHealth()
		self:TargetFrame_UpdateMana()
		self:TargetFrame_UpdateTrivial()
		self:TargetFrame_UpdateGroup()
		self:TargetFrame_UpdateBuffs()
		self:TargetFrame_UpdateDebuffs()
		
		if(not frame:IsShown()) then frame:Show() end
	else
		if(frame:IsShown()) then frame:Hide() end
	end
end



function UnitFrames:TargetFrame_OnEvent(event)
	if(event == 'PLAYER_ENTERING_WORLD') then self:TargetFrame_Update() end
	
	if(event == 'UNIT_HEALTH' or event == 'UNIT_MAXHEALTH') then
		if(arg1 == 'target') then self:TargetFrame_UpdateHealth() end
	end
	if(
		event == 'UNIT_MANA' or event == 'UNIT_ENERGY' or event == 'UNIT_RAGE' or
		event == 'UNIT_MAXMANA' or event == 'UNIT_MAXENERGY' or event == 'UNIT_MAXRAGE'
	) then
		if(arg1 == 'target') then self:TargetFrame_UpdateMana() end
	end
	
	if(event == 'UNIT_LEVEL') then
		if(arg1 == 'target') then self:TargetFrame_UpdateLevel() end
	end
	
	if(event == 'UNIT_FACTION') then
		if(arg1 == 'target') then self:TargetFrame_UpdatePvP() end
	end
	
	
	
	if(event == 'UNIT_AURA' or event == 'PLAYER_AURAS_CHANGED') then
		self:TargetFrame_UpdateBuffs()
		self:TargetFrame_UpdateDebuffs()
	end
	if(event == 'PLAYER_TARGET_CHANGED') then
		self:TargetFrame_Update()
	end
	
	if(
		event == 'PARTY_MEMBERS_CHANGED' or event == 'PARTY_LEADER_CHANGED' or
		event == 'PARTY_LOOT_METHOD_CHANGED' or
		event == 'RAID_TARGET_UPDATE'
	) then self:TargetFrame_UpdateGroup() end
end
function UnitFrames:TargetFrame_OnUpdate(elapsedSec)
	local frame = getglobal('ElronsUI_UnitFrame_TargetTarget')
	
	if(UnitExists('targettarget')) then frame:Show() end
end
function UnitFrames:TargetFrame_OnClick()
	if(SpellIsTargeting() and button == 'RightButton') then
		SpellStopTargeting()
		
		return
	end
	
	if(button == 'LeftButton') then
		if(SpellIsTargeting()) then
			SpellTargetUnit('target')
		elseif(CursorHasItem()) then
			DropItemOnUnit('target')
		else
			TargetUnit('target')
		end
	else
		ToggleDropDownMenu(1, nil, TargetFrameDropDown, 'ElronsUI_UnitFrame_Target', 0, 0)
	end
end



-- Initialize
function UnitFrames:TargetFrame_Init()
	local frame
	
	frame = self:CreateUnitFrame('target')
	
	frame:EnableMouse(true)
	frame:SetScript('OnEvent', function() self:TargetFrame_OnEvent(event) end)
	frame:SetScript('OnUpdate', function() self:TargetFrame_OnUpdate(arg1) end)
	frame:SetScript('OnMouseUp', function() self:TargetFrame_OnClick(arg1) end)
	
	frame:RegisterEvent('PLAYER_ENTERING_WORLD')
	
	frame:RegisterEvent('UNIT_COMBO_POINTS')
	frame:RegisterEvent('UNIT_DISPLAYPOWER')
	frame:RegisterEvent('UNIT_ENERGY')
	frame:RegisterEvent('UNIT_FACTION')
	frame:RegisterEvent('UNIT_HEALTH')
	frame:RegisterEvent('UNIT_LEVEL')
	frame:RegisterEvent('UNIT_MANA')
	frame:RegisterEvent('UNIT_MAXENERGY')
	frame:RegisterEvent('UNIT_MAXHEALTH')
	frame:RegisterEvent('UNIT_MAXMANA')
	frame:RegisterEvent('UNIT_MAXRAGE')
	frame:RegisterEvent('UNIT_RAGE')
	
	frame:RegisterEvent('UNIT_AURA')
	frame:RegisterEvent('PLAYER_AURAS_CHANGED')
	
	frame:RegisterEvent('PLAYER_TARGET_CHANGED')
	
	frame:RegisterEvent('UNIT_CLASSIFICATION_CHANGED')
	frame:RegisterEvent('PLAYER_FLAGS_CHANGED')
	frame:RegisterEvent('RAID_TARGET_UPDATE')
	
	frame:RegisterEvent('PARTY_MEMBERS_CHANGED')
	frame:RegisterEvent('PARTY_LEADER_CHANGED')
	frame:RegisterEvent('PARTY_LOOT_METHOD_CHANGED')
	frame:RegisterEvent('RAID_TARGET_UPDATE')
	
	-- Hide away
	frame:Hide()
	
	-- Hide away blizzard
	self:HideBlizzard('target')
	
	
	
	-- Update is important now
	self:TargetFrame_Update()
end