-- Dependencies
local Engine = getglobal('ElronsUI')
local Layout = Engine:GetModule('Layout')
local DB

-- Register new module
local UnitFrames = Engine:NewModule('UnitFrames')

-- Register variables

-- External functions

-- Internal functions



-- Class functions
function UnitFrames:HideBlizzard(type)
	if(type == 'player') then
		PlayerFrame:UnregisterAllEvents()
		PlayerFrame.Show = function() end
		PlayerFrame:Hide()
		
		BuffFrame.Show = function() end
		BuffFrame:Hide()
	end
	
	if(type == 'target') then
		TargetFrame:UnregisterAllEvents()
		TargetFrame.Show = function() end
		TargetFrame:Hide()
	end
	
	if(type == 'targettarget') then
		TargetTargetFrame:UnregisterAllEvents()
		TargetTargetFrame.Show = function() end
		TargetTargetFrame:Hide()
	end
	
	if(type == 'pet') then
		PetFrame:UnregisterAllEvents()
		PetFrame.Show = function() end
		PetFrame:Hide()
		
		PetActionBarFrame:UnregisterAllEvents()
		PetActionBarFrame.Show = function() end
		PetActionBarFrame:Hide()
	end
end

function UnitFrames:SetClassIconTexture(texture, class)
	local classIndex
	local top, bottom, left, right
	local db = Engine.DB.db.profile.general.class
	local coordIncrement = db.dimension.icon / db.dimension.texture
	class = strlower(class)
	if(class == 'none') then classIndex = -1 end
	if(class == 'warrior') then classIndex = 0 end
	if(class == 'mage') then classIndex = 1 end
	if(class == 'rogue') then classIndex = 2 end
	if(class == 'druid') then classIndex = 3 end
	if(class == 'hunter') then classIndex = 4 end
	if(class == 'shaman') then classIndex = 5 end
	if(class == 'priest') then classIndex = 6 end
	if(class == 'warlock') then classIndex = 7 end
	if(class == 'paladin') then classIndex = 8 end
	
	left = mod(classIndex, db.columns) * coordIncrement
	right = left + coordIncrement
	top = floor(classIndex / db.rows) * coordIncrement
	bottom = top + coordIncrement
	
	texture:SetTexCoord(left, right, top, bottom)
end



function UnitFrames:CreateBar(barType, name, parent, width, height, strata, level)
	local bar
	local create = false
	
	if(barType == 'health') then
		name = name..'_HealthBar'
		
		create = true
	elseif(barType == 'mana') then
		name = name..'_ManaBar'
		
		create = true
	elseif(barType == 'xp') then
		name = name..'_XPBar'
		
		create = true
	elseif(barType == 'cast') then
		name = name..'_CastBar'
		
		create = true
	end
	
	if(create == true) then
		bar = Layout:CreateStatusBar(name, parent, width, height, strata, level)
		-- Set value and color
		bar:SetMinMaxValues(0, 1)
		bar:SetValue(0.5)
		bar:SetBackdropColor(0.5, 0.5, 0.5, 0.15)
		bar:SetStatusBarColor(0.5, 0.5, 0.5, 0.5)
		
		-- Variables
		bar.info = {}
	end
	
	return bar
end

function UnitFrames:CreateBarInfos(bar, infoType)
	local layer
	
	-- Info Left
	layer = bar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	layer:SetWidth(150)
	layer:SetHeight(10)
	if(infoType == 'health') then
		layer:SetPoint('LEFT', bar, 'LEFT', 2, -4)
	else
		layer:SetPoint('LEFT', bar, 'LEFT', 2, 0)
	end
	layer:SetTextColor(1, 1, 1, 1)
	layer:SetJustifyH('LEFT')
	bar.info.left = layer
	-- Info Center
	layer = bar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	layer:SetWidth(250)
	layer:SetHeight(10)
	if(infoType == 'health') then
		layer:SetPoint('CENTER', bar, 'CENTER', 0, -4)
	else
		layer:SetPoint('CENTER', bar, 'CENTER', 0, 0)
	end
	layer:SetTextColor(1, 1, 1, 1)
	layer:SetJustifyH('CENTER')
	bar.info.center = layer
	-- Info Right
	layer = bar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	layer:SetWidth(150)
	layer:SetHeight(10)
	if(infoType == 'health') then
		layer:SetPoint('RIGHT', bar, 'RIGHT', -2, -4)
	else
		layer:SetPoint('RIGHT', bar, 'RIGHT', -2, 0)
	end
	layer:SetTextColor(1, 1, 1, 1)
	layer:SetJustifyH('RIGHT')
	bar.info.right = layer
end

function UnitFrames:CreateBarPlayerLevel(bar, unitType)
	local layer
	
	layer = bar:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
	-- Size
	layer:SetWidth(20)
	layer:SetHeight(10)
	-- Position
	if(unitType == 'player') then
		layer:SetPoint('TOPLEFT', bar, 'TOPLEFT', 2, -2)
	else
		layer:SetPoint('TOPRIGHT', bar, 'TOPRIGHT', -2, -2)
	end
	-- Font settings
	layer:SetTextColor(1, 1, 1, 1)
	if(unitType == 'player') then
		layer:SetJustifyH('LEFT')
	else
		layer:SetJustifyH('RIGHT')
	end
	-- Save as variable
	bar.info.PlayerLevel = layer
end
function UnitFrames:CreateBarPlayerClass(bar, unitType)
	local layer
	
	layer = bar:CreateTexture(nil, 'OVERLAY')
	-- Size
	layer:SetWidth(16)
	layer:SetHeight(16)
	-- Position
	if(unitType == 'player') then
		layer:SetPoint('TOPRIGHT', bar, 'TOPRIGHT', 0, 0)
	else
		layer:SetPoint('TOPLEFT', bar, 'TOPLEFT', 0, 0)
	end
	-- Texture settings
	layer:SetTexture(Engine.DB.db.profile.general.class.texture)
	self:SetClassIconTexture(layer, 'none')
	-- Save as variable
	bar.info.PlayerClass = layer
end
function UnitFrames:CreateBarPlayerFaction(bar)
	local layer
	
	layer = bar:CreateTexture(nil, 'OVERLAY')
	-- Size
	layer:SetWidth(20)
	layer:SetHeight(20)
	-- Position
	layer:SetPoint('TOP', bar, 'TOP', 15, -1)
	-- Save as variable
	bar.info.PlayerFaction = layer
end
function UnitFrames:CreateBarPlayerRank(bar)
	local layer
	
	layer = bar:CreateTexture(nil, 'OVERLAY')
	-- Size
	layer:SetWidth(10)
	layer:SetHeight(10)
	-- Position
	layer:SetPoint('TOP', bar, 'TOP', -7.5, -2)
	-- Save as variable
	bar.info.PlayerRank = layer
end
function UnitFrames:CreateBarLeaderIcon(bar, unitType)
	local layer
	
	layer = bar:CreateTexture(nil, 'OVERLAY')
	-- Size
	layer:SetWidth(20)
	layer:SetHeight(20)
	-- Position
	if(unitType == 'player') then
		layer:SetPoint('RIGHT', bar.info.PlayerClass, 'LEFT', 0, 0)
	else
		layer:SetPoint('LEFT', bar.info.PlayerClass, 'RIGHT', 0, 0)
	end
	-- Texture settings
	layer:SetTexture('Interface\\GroupFrame\\UI-Group-LeaderIcon')
	-- Hide layer
	layer:Hide()
	-- Save as variable
	bar.info.LeaderIcon = layer
end
function UnitFrames:CreateBarLootIcon(bar, unitType)
	local layer
	
	layer = bar:CreateTexture(nil, 'OVERLAY')
	-- Size
	layer:SetWidth(16)
	layer:SetHeight(16)
	-- Position
	if(unitType == 'player') then
		layer:SetPoint('RIGHT', bar.info.LeaderIcon, 'LEFT', 0, 0)
	else
		layer:SetPoint('LEFT', bar.info.LeaderIcon, 'RIGHT', 0, 0)
	end
	-- Texture settings
	layer:SetTexture('Interface\\GroupFrame\\UI-Group-MasterLooter')
	-- Hide layer
	layer:Hide()
	-- Save as variable
	bar.info.LootIcon = layer
end
function UnitFrames:CreateBarRaidIcon(bar, unitType)
	local layer
	
	layer = bar:CreateTexture(nil, 'OVERLAY')
	-- Size
	layer:SetWidth(14)
	layer:SetHeight(14)
	-- Position
	if(unitType == 'player') then
		layer:SetPoint('RIGHT', bar.info.LootIcon, 'LEFT', 0, 0)
	else
		layer:SetPoint('LEFT', bar.info.LootIcon, 'RIGHT', 0, 0)
	end
	-- Texture settings
	layer:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons', 'OVERLAY')
	-- Hide layer
	layer:Hide()
	-- Save as variable
	bar.info.RaidIcon = layer
end

function UnitFrames:CreateBuffBar(buffType, unitType, name, parent)
	local frame
	local width, height
	local point, relFrame, relPoint, oX, oY
	
	width	= ((DB.button.width * DB[unitType].buffs.max) + (4 * (DB[unitType].buffs.max + 1)))
	height	= (DB.button.height + 4)
		
	frame = Layout:CreateFrame('Frame', name, parent, width, height, false, 'BACKGROUND', 0)
	if(buffType == 'HELPFUL') then frame:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', 0, -4) end
	
	name		= name..'_Button'
	point		= 'LEFT'
	relFrame	= frame
	relPoint	= 'LEFT'
	oX			= 2
	oY			= 0
	
	local bType
	if(buffType == 'HELPFUL') then bType = 'buffs' end
	if(buffType == 'HARMFUL') then bType = 'debuffs' end
	
	for i = 1, DB[unitType][bType].max do
		if(i > 1) then
			relFrame = getglobal('ElronsUI_'..name..(i - 1))
			oX = (DB.button.width + 4)
		end
		
		button = self:CreateBuffButton(unitType, buffType, i, name..i, frame, DB.button.width, DB.button.height, 'BACKGROUND', 1)
		button:SetPoint(point, relFrame, relPoint, oX, oY)
	end
	
	
	
	--[[
			-- Create buttons
			name2		= name2..'_Button'
			parent		= buffFrame
			point		= 'LEFT'
			relFrame	= buffFrame
			relPoint	= 'LEFT'
			oX			= 2
			oY			= 0
			
			for i = 1, DB[unitType].buffs.max do
				if(i > 1) then
					relFrame = getglobal('ElronsUI_'..name2..(i - 1))
					oX = 20 + 2
				end
				
				button = self:CreateBuffButton(unitType, 'HELPFUL', (i - 1), name2..i, parent, 20, 20)
				-- Set strata and level
				button:SetFrameStrata('BACKGROUND')
				button:SetFrameLevel(3)
				-- Set position
				button:SetPoint(point, relFrame, relPoint, oX, oY)
			end
			
			
			
			name2	= name..'_DebuffFrame'
			parent	= buffFrame
			width	= buffFrame:GetWidth()
			height	= buffFrame:GetHeight()
			debuffFrame = Layout:CreateFrame('Frame', name2, parent, width, height)
			-- Set strata and level
			debuffFrame:SetFrameStrata('BACKGROUND')
			debuffFrame:SetFrameLevel(1)
			-- Set position
			debuffFrame:SetPoint('TOP', buffFrame, 'BOTTOM', 0, -4)
			
			-- Create buttons
			name2		= name2..'_Button'
			parent		= debuffFrame
			point		= 'LEFT'
			relFrame	= debuffFrame
			relPoint	= 'LEFT'
			oX			= 2
			oY			= 0
			
			for i = 1, DB[unitType].debuffs.max do
				if(i > 1) then
					relFrame = getglobal(name2..(i - 1))
					oX = 20 + 2
				end
				
				button = self:CreateBuffButton(unitType, 'HARMFUL', (i - 1), name2..i, parent, 20, 20)
				button:SetID(i - 1)
				-- Set strata and level
				button:SetFrameStrata('BACKGROUND')
				button:SetFrameLevel(3)
				-- Set position
				button:SetPoint(point, relFrame, relPoint, oX, oY)
			end
	]]--
	
	return frame
end
function UnitFrames:CreateBuffButton(unitType, buffType, buffID, name, parent, width, height, strata, level)
	local button, fString
	
	button = Layout:CreateButton(name, parent, width, height, strata, level)
	-- Setup variables
	button:SetID(buffID)
	button.buffType	= buffType
	button.unitType	= unitType
	
	-- Count string
	fString = button:CreateFontString(nil, 'OVERLAY', 'NumberFontNormalSmall')
	fString:SetPoint('BOTTOMRIGHT', 0, 0)
	fString:Hide()
	button.count = fString
	-- Cooldown string
	fString = button:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
	fString:SetPoint('TOP', -1, -1)
	fString:SetFont('Fonts\\ARIALN.TTF', 10, 'OUTLINE')
	fString:Hide()
	button.cooldown = fString
	
	-- Event handling
	button:SetScript('OnUpdate', function() self:BuffButton_OnUpdate(arg1) end)
	button:SetScript('OnEnter', function() self:BuffButton_OnEnter() end)
	button:SetScript('OnLeave', function() self:BuffButton_OnLeave() end)
	if(unitType == 'player' or unitType == 'pet') then
		button:SetScript('OnClick', function() self:BuffButton_OnClick(arg1) end)
		button:RegisterForClicks('RightButtonUp')
	end
	
	return button
end

function UnitFrames:CreateUnitFrame(unitType)
	local frame, layer
	local buffFrame, debuffFrame
	local healthBar, manaBar, xpBar, castBar
	local name, nameFull, parent, width, height, point, relFrame, relPoint, oX, oY
	local create = false
	
	-- Pre-define variables
	name		= 'UnitFrame_'
	parent		= Engine.UIParent
	width		= DB.width
	height		= DB.height
	point		= 'CENTER'
	relFrame	= parent
	relPoint	= 'CENTER'
	oX			= 0
	oY			= 0
	
	if(unitType == 'player') then
		name	= name..'Player'
		point		= 'TOPLEFT'
		relFrame	= getglobal('ElronsUI_Chat')
		relPoint	= 'TOPRIGHT'
		oX			= 4
		
		create	= true
	elseif(unitType == 'target') then
		name		= name..'Target'
		point		= 'TOPRIGHT'
		relFrame	= getglobal('ElronsUI_Log')
		relPoint	= 'TOPLEFT'
		oX			= -4
		
		create = true
	elseif(unitType == 'targettarget') then
		name		= name..'TargetTarget'
		point		= 'BOTTOMLEFT'
		relFrame	= getglobal('ElronsUI_UnitFrame_Target')
		relPoint	= 'TOPLEFT'
		oY			= 4
		
		create = true
	elseif(unitType == 'pet') then
		name		= name..'Pet'
		point		= 'BOTTOMLEFT'
		relFrame	= getglobal('ElronsUI_UnitFrame_Player')
		relPoint	= 'TOPLEFT'
		oY			= 4
		
		create = true
	end
	
	
	
	if(create == true) then
		-- Create new frame
		frame = Layout:CreateFrame('Frame', name, parent, width, height, true, 'BACKGROUND', 0)
		-- Set position
		frame:SetPoint(point, relFrame, relPoint, oX, oY)
		
		-- Create bars
		barHealth	= self:CreateBar('health', name, frame, (frame:GetWidth() - 8), (frame:GetHeight() - 20), 'BACKGROUND', 1)
		barMana		= self:CreateBar('mana', name, frame, (frame:GetWidth() - 8), 12, 'BACKGROUND', 1)
		barXP		= self:CreateBar('xp', name, frame, (frame:GetWidth() - 8), 12, 'BACKGROUND', 1)
		barCast		= self:CreateBar('cast', name, frame, (frame:GetWidth() - 8), 12, 'BACKGROUND', 1)
		-- Set positions
		barHealth:SetPoint('TOP', frame, 'TOP', 0, -4)
		barMana:SetPoint('TOP', barHealth, 'BOTTOM', 0, 0)
		barXP:SetPoint('TOP', barMana, 'BOTTOM', 0, 0)
		barCast:SetPoint('TOP', barMana, 'BOTTOM', 0, 0)
		-- Hide frames
		barXP:Hide()
		barCast:Hide()
		
		-- Buff and Debuff frames
		if(unitType ~= 'targettarget') then
			buffFrame = self:CreateBuffBar('HELPFUL', unitType, name..'_BuffBar', frame)
			debuffFrame = self:CreateBuffBar('HARMFUL', unitType, name..'_DebuffBar', frame)
			debuffFrame:SetPoint('TOPLEFT', buffFrame, 'BOTTOMLEFT', 0, -4)
		end
		
		-- Info layers
		self:CreateBarInfos(barHealth, 'health')
		self:CreateBarInfos(barMana, 'mana')
		self:CreateBarInfos(barXP, 'xp')
		self:CreateBarInfos(barCast, 'cast')
		-- PlayerName
		self:CreateBarPlayerLevel(barHealth, unitType)
		
		-- Textures
		-- PlayerClass
		self:CreateBarPlayerClass(barHealth, unitType)
		-- PlayerFaction
		self:CreateBarPlayerFaction(barHealth)
		-- PlayerRank
		self:CreateBarPlayerRank(barHealth)
		-- LeaderIcon
		self:CreateBarLeaderIcon(barHealth, unitType)
		-- LootIcon
		self:CreateBarLootIcon(barHealth, unitType)
		-- RaidIcon
		self:CreateBarRaidIcon(barHealth, unitType)
	end
	
	return frame
end



function UnitFrames:BuffButton_OnUpdate(elapsedSec)
	local buffType, buffIndex, untilCancelled, buffDuration
	local buffID = (this:GetID() - 1)
	
	buffType = this.buffType
	buffIndex, untilCancelled = GetPlayerBuff(buffID, this.buffType)
	this.buffIndex = buffIndex
	this.untilCancelled = untilCancelled
	
	buffDuration = GetPlayerBuffTimeLeft(buffIndex)
	
	if(buffIndex >= 0 and this.unitType == 'player') then
		this:SetAlpha(1.0)
		this:Show()
		
		self:BuffButton_Update(this, buffDuration)
	end
end
function UnitFrames:BuffButton_OnEnter()
	GameTooltip:SetOwner(this, 'ANCHOR_CURSOR')
	if(this.unitType == 'player') then
		GameTooltip:SetPlayerBuff(this.buffIndex)
	else
		GameTooltip:SetUnitBuff(this.unitType, this:GetID())
	end
end
function UnitFrames:BuffButton_OnLeave()
	GameTooltip:Hide()
end
function UnitFrames:BuffButton_OnClick()
	CancelPlayerBuff(this.buffIndex)
end

function UnitFrames:BuffButton_Update(buffButton, buffDuration)
	local fsCooldown = getglobal(buffButton:GetName()).cooldown
	local h, m, s
	buffDuration = tonumber(string.format('%.0f', buffDuration))
	
	if(buffDuration > 0) then
		local text = ''
		local color = {r = 0.0, g = 0.0, b = 0.0}
		h = math.floor(buffDuration / 3600)
		m = ((math.floor(buffDuration / 60)) - (math.floor((math.floor(buffDuration / 60)) / 60)) * 60)
		s = (buffDuration - (math.floor(buffDuration / 60)) * 60)
		
		if(h > 0) then
			if(strlen(m) == 1) then m = '0'..m end
			text = h..':'..m
			
			color.r = 0.25
			color.g = 0.75
			color.b = 1.0
		elseif(m > 0) then
			if(strlen(s) == 1) then s = '0'..s end
			text = m..':'..s
			
			if(m >= 50) then
				color.r	= 0.1
				color.g = 1.0
			elseif(m >= 40) then
				color.r	= 0.2
				color.g = 1.0
			elseif(m >= 30) then
				color.r	= 0.3
				color.g = 1.0
			elseif(m >= 20) then
				color.r	= 0.4
				color.g = 1.0
			elseif(m >= 10) then
				color.r	= 0.5
				color.g = 1.0
			elseif(m < 10) then
				if(m >= 8) then
					color.r	= 0.6
					color.g = 1.0
				elseif(m >= 6) then
					color.r	= 0.7
					color.g = 1.0
				elseif(m >= 4) then
					color.r	= 0.8
					color.g = 1.0
				elseif(m >= 2) then
					color.r	= 0.9
					color.g = 1.0
				elseif(m < 2) then
					color.r = 1.0
					color.g = 1.0
				end
			end
		else
			text = s
			
			if(s >= 50) then
				color.r = 1.0
				color.g = 0.9
			elseif(s >= 40) then
				color.r = 1.0
				color.g = 0.8
			elseif(s >= 30) then
				color.r = 1.0
				color.g = 0.7
			elseif(s >= 20) then
				color.r = 1.0
				color.g = 0.6
			elseif(s >= 10) then
				color.r = 1.0
				color.g = 0.5
			elseif(s < 10) then
				if(s >= 8) then
					color.r = 1.0
					color.g = 0.4
				elseif(s >= 6) then
					color.r = 1.0
					color.g = 0.3
				elseif(s >= 4) then
					color.r = 1.0
					color.g = 0.2
				elseif(s >= 2) then
					color.r = 1.0
					color.g = 0.1
				elseif(s < 2) then
					color.r = 1.0
				end
			end
		end
		
		fsCooldown:SetText(text)
		fsCooldown:SetTextColor(color.r, color.g, color.b)
		
		fsCooldown:Show()
	else
		fsCooldown:Hide()
	end
end



-- Initialize
function UnitFrames:Initialize()
	DB = Engine.DB.db.profile.unitframe
	
	self:PlayerFrame_Init()
	self:TargetFrame_Init()
	self:TargetTargetFrame_Init()
	
	return true
end



--[[
function UnitFrames:CreateBuffButton(unitType, buffType, id, name, parent, width, height)
	local button, fontString
	name = 'ElronsUI_'..name
	
	button = CreateFrame('Button', name, parent)
	-- Set width and height
	button:SetWidth(width)
	button:SetHeight(height)
	-- Setup variables
	button:SetID(id)
	button.buffType = buffType
	button.unitType = unitType
	-- Hide button
	button:Hide()
	
	-- Count string
	fontString = button:CreateFontString(name..'Count', 'OVERLAY', 'NumberFontNormalSmall')
	fontString:SetPoint('BOTTOMRIGHT', 2, 1)
	fontString:Hide()
	
	-- Cooldown string
	fontString = button:CreateFontString(name..'Cooldown', 'OVERLAY', 'NumberFontNormal')
	fontString:SetAllPoints()
	fontString:Hide()
	
	-- Event handling
	button:SetScript('OnUpdate', function() self:BuffButton_OnUpdate(arg1) end)
	button:SetScript('OnEnter', function() self:BuffButton_OnEnter() end)
	button:SetScript('OnLeave', function() self:BuffButton_OnLeave() end)
	if(unitType == 'player' or unitType == 'pet') then
		button:SetScript('OnClick', function() self:BuffButton_OnClick(arg1) end)
		button:RegisterForClicks('RightButtonUp')
	end
	
	return button
end

function UnitFrames:SetClassIconTexture(texture, class)
	local classIndex
	local top, bottom, left, right
	local db = Engine.DB.db.profile.general.class
	local coordIncrement = db.dimension.icon / db.dimension.texture
	class = strlower(class)
	if(class == 'none') then classIndex = -1 end
	if(class == 'warrior') then classIndex = 0 end
	if(class == 'mage') then classIndex = 1 end
	if(class == 'rogue') then classIndex = 2 end
	if(class == 'druid') then classIndex = 3 end
	if(class == 'hunter') then classIndex = 4 end
	if(class == 'shaman') then classIndex = 5 end
	if(class == 'priest') then classIndex = 6 end
	if(class == 'warlock') then classIndex = 7 end
	if(class == 'paladin') then classIndex = 8 end
	
	left = mod(classIndex, db.columns) * coordIncrement
	right = left + coordIncrement
	top = floor(classIndex / db.rows) * coordIncrement
	bottom = top + coordIncrement
	
	texture:SetTexCoord(left, right, top, bottom)
end
]]--