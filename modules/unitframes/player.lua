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
function UnitFrames:PlayerFrame_UpdateLevel()
	local frame = getglobal('ElronsUI_UnitFrame_Player_HealthBar').info.PlayerLevel
	
	frame:SetText(Engine.Player.Char.Level)
end

function UnitFrames:PlayerFrame_UpdateClass()
	local frame = getglobal('ElronsUI_UnitFrame_Player_HealthBar').info.PlayerClass
	
	self:SetClassIconTexture(frame, Engine.Player.Char.Class)
end

function UnitFrames:PlayerFrame_UpdateHealth()
	local valCur, valMax, valPer
	local cVal, mVal
	local bar = getglobal('ElronsUI_UnitFrame_Player_HealthBar')
	local left = bar.info.left
	local right = bar.info.right
	local color, alpha
	
	if(UnitExists('player')) then
		valCur	= UnitHealth('player')
		valMax	= UnitHealthMax('player')
		valPer	= (valCur / valMax) * 100
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
		
		left:SetText(cVal..'/'..mVal)
		right:SetText(tonumber(string.format('%.2f', valPer))..' %')
	end
end

function UnitFrames:PlayerFrame_UpdateMana()
	local valCur, valMax, valPer
	local cVal, mVal
	local bar = getglobal('ElronsUI_UnitFrame_Player_ManaBar')
	local left = bar.info.left
	local right = bar.info.right
	local class, color, alpha, powerType
	
	if(UnitExists('player')) then
		valCur	= UnitMana('player')
		valMax	= UnitManaMax('player')
		valPer	= (valCur / valMax) * 100
		class	= UnitClass('player')
		
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
		powerType = UnitPowerType('player')
		left:SetText('')
		right:SetText('')
		
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
		
		bar:SetMinMaxValues(0, valMax)
		bar:SetValue(valCur)
		bar:SetBackdropColor(color.r, color.g, color.b, alpha.bg)
		bar:SetStatusBarColor(color.r, color.g, color.b, alpha.bar)
		
		left:SetText(cVal..'/'..mVal)
		right:SetText(tonumber(string.format('%.2f', valPer))..' %')
	end
end

function UnitFrames:PlayerFrame_UpdateXP()
	local valCur, valMax, valPer
	local cVal, mVal
	local bar = getglobal('ElronsUI_UnitFrame_Player_XPBar')
	local left = bar.info.left
	local center = bar.info.center
	local right = bar.info.right
	
	if(UnitExists('player')) then
		valCur	= UnitXP('player')
		valMax	= UnitXPMax('player')
		valPer	= (valCur / valMax) * 100
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
		
		bar:SetMinMaxValues(0, valMax)
		bar:SetValue(valCur)
		
		left:SetText(cVal..'/'..mVal)
		center:SetText(valMax - valCur)
		right:SetText(tonumber(string.format('%.2f', valPer))..' %')
	end
	
	bar:SetBackdropColor(0.58, 0.0, 0.55, 0.3)
	bar:SetStatusBarColor(0.58, 0.0, 0.55, 0.75)
end

function UnitFrames:PlayerFrame_UpdateCombat()
	local frame = getglobal('ElronsUI_UnitFrame_Player')
	
	frame:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0)
	if(frame.onHateList) then frame:SetBackdropBorderColor(1.0, 0.0, 0.0, 1.0) end
end

function UnitFrames:PlayerFrame_UpdatePvP()
	local frame			= getglobal('ElronsUI_UnitFrame_Player_HealthBar')
	local rankFrame		= frame.info.PlayerRank
	local factionFrame	= frame.info.PlayerFaction
	local pvpRank		= UnitPVPRank('player')
	local factionGroup, factionName = UnitFactionGroup('player')
	
	if(pvpRank >= 5) then
		pvpRank = pvpRank - 4
		
		if(pvpRank < 10) then rankFrame:SetTexture('Interface\\PvPRankBadges\\PvPRank0'..pvpRank) end
		if(pvpRank >= 10) then rankFrame:SetTexture('Interface\\PvPRankBadges\\PvPRank'..pvpRank) end
		
		rankFrame:Show()
	else
		rankFrame:Hide()
	end
	
	if(UnitIsPVPFreeForAll('player')) then
		PlaySound('igPVPUpdate')
		factionFrame:SetTexture('Interface\\TargetingFrame\\UI-PVP-FFA')
		factionFrame:Show()
	elseif(factionGroup and UnitIsPVP('player')) then
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

function UnitFrames:PlayerFrame_UpdateGroup()
	local frame				= getglobal('ElronsUI_UnitFrame_Player_HealthBar')
	local iconLeader		= frame.info.LeaderIcon
	local iconMasterLooter	= frame.info.LootIcon
	local iconRaidMark		= frame.info.RaidIcon
	local index				= GetRaidTargetIndex('player')
	local leader
	
	if(index) then
		SetRaidTargetIconTexture(iconRaidMark, index)
		iconRaidMark:Show()
	else
		SetRaidTargetIconTexture(iconRaidMark, 0)
		iconRaidMark:Hide()
	end
	
	if(GetNumRaidMembers() > 0) then
		local method, master = GetLootMethod()
		
		if(IsRaidLeader()) then iconLeader:Show() else iconLeader:Hide() end
		if(master == 0) then iconMasterLooter:Show() else iconMasterLooter:Hide() end
	elseif(GetNumPartyMembers() > 0) then
		local method, master = GetLootMethod()
		
		if(IsPartyLeader()) then iconLeader:Show() else iconLeader:Hide() end
		if(master == 0) then iconMasterLooter:Show() else iconMasterLooter:Hide() end
	else
		iconLeader:Hide()
		iconMasterLooter:Hide()
	end
end

function UnitFrames:PlayerFrame_UpdateBuffs()
	local button, texture, count
	local fsCount, fsCooldown
	local DB = Engine.DB.db.profile.unitframe
	
	for i = 1, DB.player.buffs.max do
		button		= getglobal('ElronsUI_UnitFrame_Player_BuffBar_Button'..i)
		fsCount		= button.count
		fsCooldown	= button.cooldown
		texture, count = UnitBuff('player', i)
		
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
function UnitFrames:PlayerFrame_UpdateDebuffs()
	local button, texture, count
	local fsCount, fsCooldown
	local DB = Engine.DB.db.profile.unitframe
	
	for i = 1, DB.player.debuffs.max do
		button		= getglobal('ElronsUI_UnitFrame_Player_DebuffBar_Button'..i)
		fsCount		= button.count
		fsCooldown	= button.cooldown
		texture, count = UnitDebuff('player', i)
		
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

function UnitFrames:PlayerFrame_UpdateLayout()
	local frame = getglobal('ElronsUI_UnitFrame_Player_XPBar')
	
	-- Adjust the main frame
	if(this.isXPBarShown == true) then
		if(not frame:IsVisible()) then
			this:SetHeight(this:GetHeight() + 12)
			frame:Show()
		end
	else
		if(frame:IsVisible()) then
			this:SetHeight(this:GetHeight() - 12)
			frame:Show()
		end
	end
end
function UnitFrames:PlayerFrame_Update()
	local frame = getglobal('ElronsUI_UnitFrame_Player')
	
	if(UnitExists('player')) then
		self:PlayerFrame_UpdateLevel()
		self:PlayerFrame_UpdateClass()
		self:PlayerFrame_UpdateHealth()
		self:PlayerFrame_UpdateMana()
		self:PlayerFrame_UpdateXP()
		self:PlayerFrame_UpdateCombat()
		self:PlayerFrame_UpdatePvP()
		self:PlayerFrame_UpdateGroup()
		self:PlayerFrame_UpdateBuffs()
		self:PlayerFrame_UpdateDebuffs()
		
		if(not frame:IsShown()) then frame:Show() end
	end
end



function UnitFrames:PlayerFrame_OnEvent(event)
	if(event == 'PLAYER_ENTERING_WORLD') then
		local xpVal, xpMax = UnitXP('player'), UnitXPMax('player')
		
		this.inCombat = false
		this.onHateList = false
		if(xpVal ~= xpMax) then this.isXPBarShown = true else this.isXPBarShow = false end
	end
	
	-- Health and mana
	if(event == 'UNIT_HEALTH' or event == 'UNIT_MAXHEALTH') then
		if(arg1 == 'player') then self:PlayerFrame_UpdateHealth() end
	end
	if(
		event == 'UNIT_MANA' or event == 'UNIT_ENERGY' or event == 'UNIT_RAGE' or
		event == 'UNIT_MAXMANA' or event == 'UNIT_MAXENERGY' or event == 'UNIT_MAXRAGE'
	) then
		if(arg1 == 'player') then self:PlayerFrame_UpdateMana() end
	end
	
	-- Level up
	if(event == 'UNIT_LEVEL') then
		if(arg1 == 'player') then self:PlayerFrame_UpdateLevel() end
	end
	
	-- Faction change
	if(event == 'UNIT_FACTION') then
		if(arg1 == 'player') then self:PlayerFrame_UpdatePvP() end
	end
	
	
	
	-- Combat events
	if(event == 'PLAYER_ENTER_COMBAT') then
		this.inCombat = true
		self:PlayerFrame_UpdateCombat()
	end
	if(event == 'PLAYER_LEAVE_COMBAT') then
		this.inCombat = false
		self:PlayerFrame_UpdateCombat()
	end
	if(event == 'PLAYER_REGEN_DISABLED') then
		this.onHateList = true
		self:PlayerFrame_UpdateCombat()
	end
	if(event == 'PLAYER_REGEN_ENABLED') then
		this.onHateList = false
		self:PlayerFrame_UpdateCombat()
	end
	
	
	
	-- Buffs and Debuffs
	if(event == 'UNIT_AURA' or event == 'PLAYER_AURAS_CHANGED') then
		self:PlayerFrame_UpdateBuffs()
		self:PlayerFrame_UpdateDebuffs()
	end
	
	
	
	--if(event == 'PLAYER_UPDATE_RESTING') then self:PlayerFrame_UpdateResting() end
	if(event == 'PLAYER_XP_UPDATE') then self:PlayerFrame_UpdateXP() end
	
	if(event == 'PLAYER_TARGET_CHANGED') then self:TargetFrame_Update() end
	
	
	
	if(
		event == 'PARTY_MEMBERS_CHANGED' or event == 'PARTY_LEADER_CHANGED' or
		event == 'PARTY_LOOT_METHOD_CHANGED' or
		event == 'RAID_TARGET_UPDATE'
	) then self:PlayerFrame_UpdateGroup() end
end
function UnitFrames:PlayerFrame_OnUpdate(elapsedSec)
	self:PlayerFrame_UpdateLayout()
end
function UnitFrames:PlayerFrame_OnClick(button)
	if(SpellIsTargeting() and button == 'RightButton') then
		SpellStopTargeting()
		
		return
	end
	
	if(button == 'LeftButton') then
		if(SpellIsTargeting()) then
			SpellTargetUnit('player')
		elseif(CursorHasItem()) then
			AutoEquipCursorItem()
		else
			TargetUnit('player')
		end
	else
		ToggleDropDownMenu(1, nil, PlayerFrameDropDown, 'ElronsUI_UnitFrame_Player', 0, 0)
	end
end



-- Initialize
function UnitFrames:PlayerFrame_Init()
	local frame
	
	frame = self:CreateUnitFrame('player')
	
	frame:EnableMouse(true)
	frame:SetScript('OnEvent', function() self:PlayerFrame_OnEvent(event) end)
	frame:SetScript('OnUpdate', function() self:PlayerFrame_OnUpdate(arg1) end)
	frame:SetScript('OnMouseUp', function() self:PlayerFrame_OnClick(arg1) end)
	
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
	
	frame:RegisterEvent('PLAYER_ENTER_COMBAT')
	frame:RegisterEvent('PLAYER_LEAVE_COMBAT')
	frame:RegisterEvent('PLAYER_REGEN_DISABLED')
	frame:RegisterEvent('PLAYER_REGEN_ENABLED')
	
	frame:RegisterEvent('UNIT_AURA')
	frame:RegisterEvent('PLAYER_AURAS_CHANGED')
	
	frame:RegisterEvent('PLAYER_UPDATE_RESTING')
	frame:RegisterEvent('PLAYER_XP_UPDATE')
	
	frame:RegisterEvent('PLAYER_TARGET_CHANGED')
	
	frame:RegisterEvent('PARTY_MEMBERS_CHANGED')
	frame:RegisterEvent('PARTY_LEADER_CHANGED')
	frame:RegisterEvent('PARTY_LOOT_METHOD_CHANGED')
	frame:RegisterEvent('RAID_TARGET_UPDATE')
	
	-- Important settings
	frame.isXPBarShown = false
	
	-- Hide away
	frame:Hide()
	
	-- Hide away blizzard
	self:HideBlizzard('player')
	
	
	
	-- Update is important now
	self:PlayerFrame_Update()
end