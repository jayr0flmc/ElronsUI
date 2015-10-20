-- Dependencies
local Engine = getglobal('ElronsUI')
local Layout = Engine:GetModule('Layout')
local Chat = Engine:GetModule('Chat')
local DB

-- Register variables

-- External functions

-- Internal functions



-- Class functions
function Chat:Loot_OnEvent(event)
	local output, prefixTime, prefixPlayer
	local h, m = GetGameTime()
	local message, author, language, channelString, target, flags, zoneID, channelID, channelName
	local type, info, channelLength
	
	output = ''
	if(strlen(h) == 1) then h = '0'..h end
	if(strlen(m) == 1) then h = '0'..m end
	prefixTime = '['..h..':'..m..'] '
	prefixPlayer = ''
	
	if(event == 'CANCEL_LOOT_ROLL') then
		--[[
		this:AddMessage('Event: '..event)
		this:AddMessage('arg1: '..tostring(arg1))
		this:AddMessage('arg2: '..tostring(arg2))
		this:AddMessage('arg3: '..tostring(arg3))
		this:AddMessage('arg4: '..tostring(arg4))
		this:AddMessage('arg5: '..tostring(arg5))
		this:AddMessage('arg6: '..tostring(arg6))
		this:AddMessage('arg7: '..tostring(arg7))
		this:AddMessage('arg8: '..tostring(arg8))
		this:AddMessage('arg9: '..tostring(arg9))
		]]--
	end
	
	if(strsub(event, 1, 8) == 'CHAT_MSG') then
		message			= arg1
		sender			= arg2
		language		= arg3
		channelString	= arg4
		target			= arg5
		flags			= arg6
		zoneID			= arg7
		channelID		= arg8
		channelName		= arg9
		
		type			= strsub(event, 10)
		info			= ChatTypeInfo[type]
		
		if(type == 'LOOT') then this:AddMessage(message, info.r, info.g, info.b, info.id) end
		if(type == 'MONEY') then this:AddMessage(message, info.r, info.g, info.b, info.id) end
	end
	
	if(event == 'CONFIRM_DISENCHANT_ROLL') then
		--[[
		this:AddMessage('Event: '..event)
		this:AddMessage('arg1: '..tostring(arg1))
		this:AddMessage('arg2: '..tostring(arg2))
		this:AddMessage('arg3: '..tostring(arg3))
		this:AddMessage('arg4: '..tostring(arg4))
		this:AddMessage('arg5: '..tostring(arg5))
		this:AddMessage('arg6: '..tostring(arg6))
		this:AddMessage('arg7: '..tostring(arg7))
		this:AddMessage('arg8: '..tostring(arg8))
		this:AddMessage('arg9: '..tostring(arg9))
		]]--
	end
	if(event == 'CONFIRM_LOOT_ROLL') then
		--[[
		this:AddMessage('Event: '..event)
		this:AddMessage('arg1: '..tostring(arg1))
		this:AddMessage('arg2: '..tostring(arg2))
		this:AddMessage('arg3: '..tostring(arg3))
		this:AddMessage('arg4: '..tostring(arg4))
		this:AddMessage('arg5: '..tostring(arg5))
		this:AddMessage('arg6: '..tostring(arg6))
		this:AddMessage('arg7: '..tostring(arg7))
		this:AddMessage('arg8: '..tostring(arg8))
		this:AddMessage('arg9: '..tostring(arg9))
		]]--
	end
	if(event == 'PARTY_LOOT_METHOD_CHANGED') then
		--[[
		this:AddMessage('Event: '..event)
		this:AddMessage('arg1: '..tostring(arg1))
		this:AddMessage('arg2: '..tostring(arg2))
		this:AddMessage('arg3: '..tostring(arg3))
		this:AddMessage('arg4: '..tostring(arg4))
		this:AddMessage('arg5: '..tostring(arg5))
		this:AddMessage('arg6: '..tostring(arg6))
		this:AddMessage('arg7: '..tostring(arg7))
		this:AddMessage('arg8: '..tostring(arg8))
		this:AddMessage('arg9: '..tostring(arg9))
		]]--
	end
	if(event == 'START_LOOT_ROLL') then
		--[[
		this:AddMessage('Event: '..event)
		this:AddMessage('arg1: '..tostring(arg1))
		this:AddMessage('arg2: '..tostring(arg2))
		this:AddMessage('arg3: '..tostring(arg3))
		this:AddMessage('arg4: '..tostring(arg4))
		this:AddMessage('arg5: '..tostring(arg5))
		this:AddMessage('arg6: '..tostring(arg6))
		this:AddMessage('arg7: '..tostring(arg7))
		this:AddMessage('arg8: '..tostring(arg8))
		this:AddMessage('arg9: '..tostring(arg9))
		]]--
	end
	if(event == 'UPDATE_MASTER_LOOT_LIST') then
		--[[
		this:AddMessage('Event: '..event)
		this:AddMessage('arg1: '..tostring(arg1))
		this:AddMessage('arg2: '..tostring(arg2))
		this:AddMessage('arg3: '..tostring(arg3))
		this:AddMessage('arg4: '..tostring(arg4))
		this:AddMessage('arg5: '..tostring(arg5))
		this:AddMessage('arg6: '..tostring(arg6))
		this:AddMessage('arg7: '..tostring(arg7))
		this:AddMessage('arg8: '..tostring(arg8))
		this:AddMessage('arg9: '..tostring(arg9))
		]]--
	end
end



-- Initialize
function Chat:Loot_Init()
	local frame
	local w, h
	
	-- Bring in database
	DB = Engine.DB.db.profile.chat
	
	-- Calculate width and height
	w = (DB.width - 8)
	h = (DB.height - (20 * 2) - 16)
	
	-- Create frame
	frame = Layout:CreateFrame('ScrollingMessageFrame', 'Log_Loot', getglobal('ElronsUI_Log'), w, h)
	-- Set strata and level
	frame:SetFrameStrata('BACKGROUND')
	frame:SetFrameLevel(1)
	-- Set font settings
	frame:SetFontObject(DB.font)
	frame:SetJustifyH(DB.justifyH)
	
	-- History settings
	frame:SetMaxLines(DB.historyMaxLines)
	
	-- Fading
	frame:SetTimeVisible(DB.interval.throttle)
	
	-- Event handling
	frame:EnableMouseWheel(true)
	frame:SetScript('OnMouseWheel', function()
		if(arg1 > 0) then
			this:ScrollUp()
		elseif(arg1 < 0) then
			this:ScrollDown()
		end
	end)
	frame:SetScript('OnEvent', function() Chat:Loot_OnEvent(event) end)
	frame:SetScript('OnHyperlinkClick', function() Chat:OnHyperlinkShow(arg1, arg2, arg3) end)
	frame:RegisterEvent('CANCEL_LOOT_ROLL')
	frame:RegisterEvent('CHAT_MSG_LOOT')
	frame:RegisterEvent('CHAT_MSG_MONEY')
	frame:RegisterEvent('CONFIRM_DISENCHANT_ROLL')
	frame:RegisterEvent('CONFIRM_LOOT_ROLL')
	frame:RegisterEvent('PARTY_LOOT_METHOD_CHANGED')
	frame:RegisterEvent('START_LOOT_ROLL')
	frame:RegisterEvent('UPDATE_MASTER_LOOT_LIST')
	
	-- Hide frame
	frame:Hide()
end