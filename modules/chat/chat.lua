-- Dependencies
local Engine = getglobal('ElronsUI')
local Layout = Engine:GetModule('Layout')
local DB

-- Register new module
local Chat = Engine:NewModule('Chat')

-- Register variables
Chat.buttonUp	= false
Chat.buttonDown	= false

-- External functions
function GetToggleStateChat()
	return DB.toggle.chat
end
function SetToggleStateChat(toggle)
	DB.toggle.chat = toggle
end

function GetToggleStateLog()
	return DB.toggle.log
end
function SetToggleStateLog(toggle)
	DB.toggle.log = toggle
end

function ChatScrollUp_HotkeyPressed(state)
	Chat.buttonUp = (state == 'down')
end
function ChatScrollDown_HotkeyPressed(state)
	Chat.buttonDown = (state == 'down')
end

-- Internal functions



-- Class functions
function Chat:OnHyperlinkClick(link, text, button)
	SetItemRef(link, text, button)
end

function Chat:TabChat_OnUpdate(frame, elapsedSec)
	local info = ChatTypeInfo['SAY']
	
	if(frame == 'GENERAL') then info = ChatTypeInfo['SYSTEM'] end
	if(frame == 'GUILD') then info = ChatTypeInfo['GUILD'] end
	if(frame == 'PARTY') then info = ChatTypeInfo['PARTY'] end
	if(frame == 'RAID') then info = ChatTypeInfo['RAID'] end
	
	if(this.hover == true) then
		this.text:SetTextColor(info.r, info.g, info.b, 1.0)
	elseif(this.active == true) then
		this.text:SetTextColor(info.r, info.g, info.b, 0.75)
	else
		this.text:SetTextColor(info.r, info.g, info.b, 0.25)
	end
end
function Chat:TabChat_OnEnter()
	this.hover = true
end
function Chat:TabChat_OnLeave()
	this.hover = false
end
function Chat:TabChat_OnClick(frame, button)
	local general		= getglobal('ElronsUI_Chat_General')
	local guild			= getglobal('ElronsUI_Chat_Guild')
	local party			= getglobal('ElronsUI_Chat_Party')
	local raid			= getglobal('ElronsUI_Chat_Raid')
	local lfg			= getglobal('ElronsUI_Chat_LFG')
	
	local tabGeneral	= getglobal('ElronsUI_Chat_TabGeneral')
	local tabGuild		= getglobal('ElronsUI_Chat_TabGuild')
	local tabParty		= getglobal('ElronsUI_Chat_TabParty')
	local tabRaid		= getglobal('ElronsUI_Chat_TabRaid')
	local tabLFG		= getglobal('ElronsUI_Chat_TabLFG')
	
	if(general ~= nil) then general:Hide() end
	if(guild ~= nil) then guild:Hide() end
	if(party ~= nil) then party:Hide() end
	if(raid ~= nil) then raid:Hide() end
	if(lfg ~= nil) then lfg:Hide() end
	tabGeneral.active = false
	tabGuild.active = false
	tabParty.active = false
	tabRaid.active = false
	tabLFG.active = false
	
	if(frame == 'GUILD' and guild ~= nil) then
		guild:Show()
		tabGuild.active = true
	elseif(frame == 'PARTY' and party ~= nil) then
		party:Show()
		tabParty.active = true
	elseif(frame == 'RAID' and raid ~= nil) then
		raid:Show()
		tabRaid.active = true
	elseif(frame == 'LFG' and lfg ~= nil) then
		lfg:Show()
		tabLFG.active = true
	else
		general:Show()
		tabGeneral.active = true
	end
end

function Chat:TabLog_OnUpdate(frame, elapsedSec)
	local info = ChatTypeInfo['SAY']
	
	if(frame == 'COMBAT') then info = ChatTypeInfo['COMBAT_MISC_INFO'] end
	if(frame == 'LOOT') then info = ChatTypeInfo['LOOT'] end
	if(frame == 'ERROR') then info = ChatTypeInfo['YELL'] end
	
	if(this.hover == true) then
		this.text:SetTextColor(info.r, info.g, info.b, 1.0)
	elseif(this.active == true) then
		this.text:SetTextColor(info.r, info.g, info.b, 0.75)
	else
		this.text:SetTextColor(info.r, info.g, info.b, 0.25)
	end
end
function Chat:TabLog_OnEnter()
	this.hover = true
end
function Chat:TabLog_OnLeave()
	this.hover = false
end
function Chat:TabLog_OnClick(frame, button)
	local combat	= getglobal('ElronsUI_Log_Combat')
	local loot		= getglobal('ElronsUI_Log_Loot')
	local error		= getglobal('ElronsUI_Log_Error')
	
	local tabCombat	= getglobal('ElronsUI_Log_TabCombat')
	local tabLoot	= getglobal('ElronsUI_Log_TabLoot')
	local tabError	= getglobal('ElronsUI_Log_TabError')
	
	if(combat ~= nil) then combat:Hide() end
	if(loot ~= nil) then loot:Hide() end
	if(error ~= nil) then error:Hide() end
	tabCombat.active = false
	tabLoot.active = false
	tabError.active = false
	
	if(frame == 'COMBAT' and combat ~= nil) then
		combat:Show()
		tabCombat.active = true
	elseif(frame == 'LOOT' and loot ~= nil) then
		loot:Show()
		tabLoot.active = true
	elseif(frame == 'ERROR' and error ~= nil) then
		error:Show()
		tabError.active = true
	end
end



function Chat:CreateTab(name, parent, width, height, point, relFrame, relPoint, oX, oY)
	local tab
	
	tab = Layout:CreateFrame('Frame', name, parent, width, height, true, 'LOW', 1)
	-- Set position
	tab:SetPoint(point, relFrame, relPoint, oX, oY)
	-- Set font, color and text
	tab.text = tab:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	tab.text:SetAllPoints()
	tab.text:SetTextColor(1, 1, 1, 1)
	tab.text:SetText('')
	-- Variables
	tab.active	= false
	tab.hover	= false
	
	return tab
end

function Chat:CreateLayoutChat()
	local areaChat
	local barTop, barBot
	local tab
	local tabGeneral, tabGuild, tabParty, tabRaid, tabLFG
	
	areaChat = Layout:CreateWindow('Chat', Engine.UIParent, DB.width, DB.height, 'BACKGROUND', 0)
	areaChat:SetPoint('BOTTOMLEFT', Engine.UIParent, 'BOTTOMLEFT', 4, 4)
	barTop = Layout:CreateFrame('Frame', 'Chat_BarTop', areaChat, (DB.width - 8), 20, true, 'BACKGROUND', 0)
	barTop:SetPoint('TOP', areaChat, 'TOP', 0, -4)
	barBot = Layout:CreateFrame('Frame', 'Chat_BarBot', areaChat, DB.width - 8, 20, true, 'BACKGROUND', 0)
	barBot:SetPoint('BOTTOM', areaChat, 'BOTTOM', 0, 4)
	
	-- Tabs
	-- General
	tab = self:CreateTab('Chat_TabGeneral', barTop, (barTop:GetWidth() - (4 * 4)) / 5, barTop:GetHeight(), 'LEFT', barTop, 'LEFT', 0, 0)
	tab.active = true
	-- Set text
	tab.text:SetText('General')
	-- Event handling
	tab:EnableMouse(true)
	tab:SetScript('OnUpdate', function() self:TabChat_OnUpdate('GENERAL', arg1) end)
	tab:SetScript('OnEnter', function() self:TabChat_OnEnter() end)
	tab:SetScript('OnLeave', function() self:TabChat_OnLeave() end)
	tab:SetScript('OnMouseUp', function() self:TabChat_OnClick('GENERAL', arg1) end)
	-- Save as variable
	tabGeneral = tab
	
	-- Guild
	tab = self:CreateTab('Chat_TabGuild', barTop, (barTop:GetWidth() - (4 * 4)) / 5, barTop:GetHeight(), 'LEFT', tabGeneral, 'RIGHT', 4, 0)
	-- Set text
	tab.text:SetText('Guild')
	-- Event handling
	tab:EnableMouse(true)
	tab:SetScript('OnUpdate', function() self:TabChat_OnUpdate('GUILD', arg1) end)
	tab:SetScript('OnEnter', function() self:TabChat_OnEnter() end)
	tab:SetScript('OnLeave', function() self:TabChat_OnLeave() end)
	tab:SetScript('OnMouseUp', function() self:TabChat_OnClick('GUILD', arg1) end)
	-- Save as variable
	tabGuild = tab
	
	-- Party
	tab = self:CreateTab('Chat_TabParty', barTop, (barTop:GetWidth() - (4 * 4)) / 5, barTop:GetHeight(), 'LEFT', tabGuild, 'RIGHT', 4, 0)
	-- Set text
	tab.text:SetText('Party')
	-- Event handling
	tab:EnableMouse(true)
	tab:SetScript('OnUpdate', function() self:TabChat_OnUpdate('PARTY', arg1) end)
	tab:SetScript('OnEnter', function() self:TabChat_OnEnter() end)
	tab:SetScript('OnLeave', function() self:TabChat_OnLeave() end)
	tab:SetScript('OnMouseUp', function() self:TabChat_OnClick('PARTY', arg1) end)
	-- Save as variable
	tabParty = tab
	
	-- Raid
	tab = self:CreateTab('Chat_TabRaid', barTop, (barTop:GetWidth() - (4 * 4)) / 5, barTop:GetHeight(), 'LEFT', tabParty, 'RIGHT', 4, 0)
	-- Set text
	tab.text:SetText('Raid')
	-- Event handling
	tab:EnableMouse(true)
	tab:SetScript('OnUpdate', function() self:TabChat_OnUpdate('RAID', arg1) end)
	tab:SetScript('OnEnter', function() self:TabChat_OnEnter() end)
	tab:SetScript('OnLeave', function() self:TabChat_OnLeave() end)
	tab:SetScript('OnMouseUp', function() self:TabChat_OnClick('RAID', arg1) end)
	-- Save as variable
	tabRaid = tab
	
	-- LFG
	tab = self:CreateTab('Chat_TabLFG', barTop, (barTop:GetWidth() - (4 * 4)) / 5, barTop:GetHeight(), 'LEFT', tabRaid, 'RIGHT', 4, 0)
	-- Set text
	tab.text:SetText('LFG')
	-- Event handling
	tab:EnableMouse(true)
	tab:SetScript('OnUpdate', function() self:TabChat_OnUpdate('LFG', arg1) end)
	tab:SetScript('OnEnter', function() self:TabChat_OnEnter() end)
	tab:SetScript('OnLeave', function() self:TabChat_OnLeave() end)
	tab:SetScript('OnMouseUp', function() self:TabChat_OnClick('LFG', arg1) end)
	-- Save as variable
	tabLFG = tab
end
function Chat:CreateLayoutLog()
	local areaLog
	local barTop, barBot
	local tab
	local tabCombat, tabLoot, tabError
	
	areaLog = Layout:CreateWindow('Log', Engine.UIParent, DB.width, DB.height)
	areaLog:SetPoint('BOTTOMRIGHT', Engine.UIParent, 'BOTTOMRIGHT', -4, 4)
	areaLog:SetFrameStrata('BACKGROUND')
	areaLog:SetFrameLevel(0)
	barTop = Layout:CreateWindow('Log_BarTop', areaLog, DB.width - 8, 20)
	barTop:SetPoint('TOP', areaLog, 'TOP', 0, -4)
	barBot = Layout:CreateWindow('Log_BarBot', areaLog, DB.width - 8, 20)
	barBot:SetPoint('BOTTOM', areaLog, 'BOTTOM', 0, 4)
	
	-- Tabs
	-- Combat Log
	tab = self:CreateTab('Log_TabCombat', barTop, (barTop:GetWidth() - (2 * 4)) / 3, barTop:GetHeight(), 'LEFT', barTop, 'LEFT', 0, 0)
	tab.active = true
	-- Set text
	tab.text:SetText('Combat Log')
	-- Event handling
	tab:EnableMouse(true)
	tab:SetScript('OnUpdate', function() self:TabLog_OnUpdate('COMBAT', arg1) end)
	tab:SetScript('OnEnter', function() self:TabLog_OnEnter() end)
	tab:SetScript('OnLeave', function() self:TabLog_OnLeave() end)
	tab:SetScript('OnMouseUp', function() self:TabLog_OnClick('COMBAT', arg1) end)
	-- Save as variable
	tabCombat = tab
	
	-- Loot Log
	tab = self:CreateTab('Log_TabLoot', barTop, (barTop:GetWidth() - (2 * 4)) / 3, barTop:GetHeight(), 'LEFT', tabCombat, 'RIGHT', 4, 0)
	-- Set text
	tab.text:SetText('Loot Log')
	-- Event handling
	tab:EnableMouse(true)
	tab:SetScript('OnUpdate', function() self:TabLog_OnUpdate('LOOT', arg1) end)
	tab:SetScript('OnEnter', function() self:TabLog_OnEnter() end)
	tab:SetScript('OnLeave', function() self:TabLog_OnLeave() end)
	tab:SetScript('OnMouseUp', function() self:TabLog_OnClick('LOOT', arg1) end)
	-- Save as variable
	tabLoot = tab
	
	-- Error Log
	tab = self:CreateTab('Log_TabError', barTop, (barTop:GetWidth() - (2 * 4)) / 3, barTop:GetHeight(), 'LEFT', tabLoot, 'RIGHT', 4, 0)
	-- Set text
	tab.text:SetText('Error Log')
	-- Event handling
	tab:EnableMouse(true)
	tab:SetScript('OnUpdate', function() self:TabLog_OnUpdate('ERROR', arg1) end)
	tab:SetScript('OnEnter', function() self:TabLog_OnEnter() end)
	tab:SetScript('OnLeave', function() self:TabLog_OnLeave() end)
	tab:SetScript('OnMouseUp', function() self:TabLog_OnClick('ERROR', arg1) end)
	-- Save as variable
	tabError = tab
end

function Chat:CreateLayout()
	self:CreateLayoutChat()
	self:CreateLayoutLog()
end



-- Initialize
function Chat:Initialize()
	DB = Engine.DB.db.profile.chat
	
	self:CreateLayout()
	
	self:General_Init()
	self:Guild_Init()
	self:Party_Init()
	self:Raid_Init()
	self:LFG_Init()
	
	self:Combat_Init()
	self:Loot_Init()
	self:Error_Init()
	
	return true
end