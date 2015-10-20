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
function UnitFrames:TargetTargetFrame_UpdateName()
	local frame = getglobal('ElronsUI_UnitFrame_TargetTarget_HealthBar').info.center
	local unitName, unitClass, unitColor
	local DB = Engine.DB.db.profile.general.class
	
	if(UnitExists('targettarget')) then
		unitName	= UnitName('targettarget')
		unitClass	= UnitClass('targettarget')
		unitColor	= {r = 1.0, g = 1.0, b = 1.0}
		if(unitClass) then unitColor = DB[strlower(unitClass)].color end
		if(UnitPVPRank('targettarget') >= 5) then unitName = UnitPVPName('targettarget') end
		
		frame:SetTextColor(unitColor.r, unitColor.g, unitColor.b)
		frame:SetText(unitName)
	end
end

function UnitFrames:TargetTargetFrame_UpdateLevel()
	local frame = getglobal('ElronsUI_UnitFrame_TargetTarget_HealthBar')
	local level, color
	
	level = UnitLevel('targettarget')
	
	if(UnitIsCorpse('targettarget')) then
		frame.info.PlayerLevel:Hide()
	elseif(level > 0) then
		-- Normal level target
		frame.info.PlayerLevel:SetText(level)
		
		-- Color level number
		if(UnitCanAttack('player', 'targettarget')) then
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

function UnitFrames:TargetTargetFrame_UpdateClass()
	local frame = getglobal('ElronsUI_UnitFrame_TargetTarget_HealthBar')
	local unitClass = UnitClass('targettarget')
	if(not unitClass) then unitClass = 'none' end
	if(not UnitIsPlayer('targettarget')) then unitClass = 'none' end
	
	self:SetClassIconTexture(frame.info.PlayerClass, unitClass)
end

function UnitFrames:TargetTargetFrame_UpdatePvP()
	local frame			= getglobal('ElronsUI_UnitFrame_TargetTarget_HealthBar')
	local rankFrame		= frame.info.PlayerRank
	local factionFrame	= frame.info.PlayerFaction
	local pvpRank		= UnitPVPRank('targettarget')
	local factionGroup, factionName = UnitFactionGroup('targettarget')
	
	if(pvpRank >= 5) then
		pvpRank = pvpRank - 4
		
		if(pvpRank < 10) then rankFrame:SetTexture('Interface\\PvPRankBadges\\PvPRank0'..pvpRank) end
		if(pvpRank >= 10) then rankFrame:SetTexture('Interface\\PvPRankBadges\\PvPRank'..pvpRank) end
		
		rankFrame:Show()
	else
		rankFrame:Hide()
	end
	
	if(UnitIsPVPFreeForAll('targettarget')) then
		PlaySound('igPVPUpdate')
		factionFrame:SetTexture('Interface\\TargetingFrame\\UI-PVP-FFA')
		factionFrame:Show()
	elseif(factionGroup and UnitIsPVP('targettarget')) then
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

function UnitFrames:TargetTargetFrame_UpdateHealth()
	local valCur, valMax, valPer
	local cVal, mVal
	local bar = getglobal('ElronsUI_UnitFrame_TargetTarget_HealthBar')
	local left = bar.info.left
	local right = bar.info.right
	local color, alpha
	
	if(UnitExists('targettarget')) then
		valCur	= UnitHealth('targettarget')
		valMax	= UnitHealthMax('targettarget')
		
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

function UnitFrames:TargetTargetFrame_UpdateMana()
	local valCur, valMax, valPer
	local cVal, mVal
	local bar = getglobal('ElronsUI_UnitFrame_TargetTarget_ManaBar')
	local left = bar.info.left
	local right = bar.info.right
	local isPlayer, class, color, alpha, powerType
	
	if(UnitExists('targettarget')) then
		valCur		= UnitMana('targettarget')
		valMax		= UnitManaMax('targettarget')
		valPer		= (valCur / valMax) * 100
		isPlayer	= UnitIsPlayer('targettarget')
		class		= UnitClass('targettarget')
		
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
		powerType = UnitPowerType('targettarget')
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

function UnitFrames:TargetTargetFrame_UpdateTrivial()
	local bar = getglobal('ElronsUI_UnitFrame_TargetTarget_HealthBar')
	
	if(UnitIsTrivial('targettarget')) then
		bar:SetBackdropColor(0.5, 0.5, 0.5, 0.15)
		bar:SetStatusBarColor(0.5, 0.5, 0.5, 0.5)
	end
end

function UnitFrames:TargetTargetFrame_UpdateGroup()
	local frame				= getglobal('ElronsUI_UnitFrame_TargetTarget_HealthBar')
	local iconLeader		= frame.info.LeaderIcon
	local iconMasterLooter	= frame.info.LootIcon
	local iconRaidMark		= frame.info.RaidIcon
	local index				= GetRaidTargetIndex('targettarget')
	local inParty			= UnitInParty('targettarget')
	local inRaid			= UnitInRaid('targettarget')
	
	if(index) then
		SetRaidTargetIconTexture(iconRaidMark, index)
		iconRaidMark:Show()
	else
		SetRaidTargetIconTexture(iconRaidMark, 0)
		iconRaidMark:Hide()
	end
	
	if(inParty or inRaid) then
		local method, master = GetLootMethod()
		
		if(UnitIsPartyLeader('targettarget')) then iconLeader:Show() else iconLeader:Hide() end
	else
		iconLeader:Hide()
		iconMasterLooter:Hide()
	end
end

function UnitFrames:TargetFrame_UpdateLayout()
end
function UnitFrames:TargetTargetFrame_Update()
	local frame = getglobal('ElronsUI_UnitFrame_TargetTarget')
	
	if(UnitExists('target') and UnitExists('targettarget')) then
		self:TargetTargetFrame_UpdateName()
		self:TargetTargetFrame_UpdateLevel()
		self:TargetTargetFrame_UpdateClass()
		self:TargetTargetFrame_UpdatePvP()
		self:TargetTargetFrame_UpdateHealth()
		self:TargetTargetFrame_UpdateMana()
		self:TargetTargetFrame_UpdateTrivial()
		self:TargetTargetFrame_UpdateGroup()
		
		frame:Show()
	else
		frame:Hide()
	end
end



function UnitFrames:TargetTargetFrame_OnEvent(event)
	if(event == 'PLAYER_ENTERING_WORLD') then self:TargetTargetFrame_Update() end
	
	if(event == 'UNIT_HEALTH' or event == 'UNIT_MAXHEALTH') then
		if(arg1 == 'targettarget') then self:TargetTargetFrame_UpdateHealth() end
	end
	if(
		event == 'UNIT_MANA' or event == 'UNIT_ENERGY' or event == 'UNIT_RAGE' or
		event == 'UNIT_MAXMANA' or event == 'UNIT_MAXENERGY' or event == 'UNIT_MAXRAGE'
	) then
		if(arg1 == 'targettarget') then self:TargetTargetFrame_UpdateMana() end
	end
	
	if(event == 'UNIT_LEVEL') then
		if(arg1 == 'targettarget') then self:TargetTargetFrame_UpdateLevel() end
	end
	
	if(event == 'UNIT_FACTION') then
		if(arg1 == 'targettarget') then self:TargetTargetFrame_UpdatePvP() end
	end
	
	
	
	if(event == 'PLAYER_TARGET_CHANGED') then self:TargetTargetFrame_Update() end
	
	if(
		event == 'PARTY_MEMBERS_CHANGED' or event == 'PARTY_LEADER_CHANGED' or
		event == 'PARTY_LOOT_METHOD_CHANGED' or
		event == 'RAID_TARGET_UPDATE'
	) then self:TargetTargetFrame_UpdateGroup() end
end
function UnitFrames:TargetTargetFrame_OnUpdate(elapsedSec)
	local frame = getglobal('ElronsUI_UnitFrame_TargetTarget')
	
	if(frame.curTarget ~= UnitName('targettarget')) then
		frame.curTarget = UnitName('targettarget')
		self:TargetTargetFrame_UpdateName()
	end
	
	self:TargetTargetFrame_Update()
end
function UnitFrames:TargetTargetFrame_OnClick(button)
	if(SpellIsTargeting() and button == 'RightButton') then
		SpellStopTargeting()
		
		return
	end
	
	if(button == 'LeftButton') then
		if(SpellIsTargeting()) then
			SpellTargetUnit('targettarget')
		elseif(CursorHasItem()) then
			DropItemOnUnit('targettarget')
		else
			TargetUnit('targettarget')
		end
	else
		ToggleDropDownMenu(1, nil, TargetOfTargetFrameDropDown, 'ElronsUI_UnitFrame_TargetTarget', 0, 0)
	end
end



function UnitFrames:TargetTargetFrame_Init()
	local frame
	
	frame = self:CreateUnitFrame('targettarget')
	
	frame:EnableMouse(true)
	frame:SetScript('OnEvent', function() self:TargetTargetFrame_OnEvent(event) end)
	frame:SetScript('OnUpdate', function() self:TargetTargetFrame_OnUpdate(arg1) end)
	frame:SetScript('OnMouseUp', function() self:TargetTargetFrame_OnClick(arg1) end)
	
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
	
	frame:RegisterEvent('PLAYER_TARGET_CHANGED')
	
	frame:RegisterEvent('PARTY_MEMBERS_CHANGED')
	frame:RegisterEvent('PARTY_LEADER_CHANGED')
	frame:RegisterEvent('PARTY_LOOT_METHOD_CHANGED')
	frame:RegisterEvent('RAID_TARGET_UPDATE')
	
	-- Hide away
	--frame:Hide()
	
	-- Hide away blizzard
	self:HideBlizzard('targettarget')
	
	
	
	-- Update is important now
	self:TargetTargetFrame_Update()
end