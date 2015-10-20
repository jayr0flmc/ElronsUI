-- Dependencies
local Engine = getglobal('ElronsUI')
local Layout = Engine:GetModule('Layout')
local Chat = Engine:GetModule('Chat')
local DB

-- Register variables

-- External functions

-- Internal functions



-- Class functions
function Chat:Error_OnEvent(event)
	local output, prefixTime, prefixPlayer
	local h, m = GetGameTime()
	local message, author, language, channelString, target, flags, zoneID, channelID, channelName
	local type, info, channelLength
	
	output = ''
	if(strlen(h) == 1) then h = '0'..h end
	if(strlen(m) == 1) then h = '0'..m end
	prefixTime = '['..h..':'..m..'] '
	prefixPlayer = ''
	
	if(event == 'SYSMSG') then this:AddMessage(arg1, arg2, arg3, arg4) end
	if(event == 'ADDON_ACTION_FORBIDDEN') then
		Engine:Debug('Event: '..event, 'debug')
		Engine:Debug('arg1: '..tostring(arg1), 'debug')
		Engine:Debug('arg2: '..tostring(arg2), 'debug')
		Engine:Debug('arg3: '..tostring(arg3), 'debug')
		Engine:Debug('arg4: '..tostring(arg4), 'debug')
		Engine:Debug('arg5: '..tostring(arg5), 'debug')
		Engine:Debug('arg6: '..tostring(arg6), 'debug')
		Engine:Debug('arg7: '..tostring(arg7), 'debug')
		Engine:Debug('arg8: '..tostring(arg8), 'debug')
		Engine:Debug('arg9: '..tostring(arg9), 'debug')
	end
	if(event == 'MACRO_ACTION_BLOCKED') then
		Engine:Debug('Event: '..event, 'debug')
		Engine:Debug('arg1: '..tostring(arg1), 'debug')
		Engine:Debug('arg2: '..tostring(arg2), 'debug')
		Engine:Debug('arg3: '..tostring(arg3), 'debug')
		Engine:Debug('arg4: '..tostring(arg4), 'debug')
		Engine:Debug('arg5: '..tostring(arg5), 'debug')
		Engine:Debug('arg6: '..tostring(arg6), 'debug')
		Engine:Debug('arg7: '..tostring(arg7), 'debug')
		Engine:Debug('arg8: '..tostring(arg8), 'debug')
		Engine:Debug('arg9: '..tostring(arg9), 'debug')
	end
	if(event == 'SCREENSHOT_FAILED') then
		Engine:Debug('Event: '..event, 'debug')
		Engine:Debug('arg1: '..tostring(arg1), 'debug')
		Engine:Debug('arg2: '..tostring(arg2), 'debug')
		Engine:Debug('arg3: '..tostring(arg3), 'debug')
		Engine:Debug('arg4: '..tostring(arg4), 'debug')
		Engine:Debug('arg5: '..tostring(arg5), 'debug')
		Engine:Debug('arg6: '..tostring(arg6), 'debug')
		Engine:Debug('arg7: '..tostring(arg7), 'debug')
		Engine:Debug('arg8: '..tostring(arg8), 'debug')
		Engine:Debug('arg9: '..tostring(arg9), 'debug')
	end
	if(event == 'UI_ERROR_MESSAGE') then this:AddMessage(arg1, 1, 0, 0) end
	if(event == 'UI_INFO_MESSAGE') then this:AddMessage(arg1, 1, 1, 0) end
end



-- Initialize
function Chat:Error_Init()
	local frame
	local w, h
	
	-- Bring in database
	DB = Engine.DB.db.profile.chat
	
	-- Calculate width and height
	w = (DB.width - 8)
	h = (DB.height - (20 * 2) - 16)
	
	-- Create frame
	frame = Layout:CreateFrame('ScrollingMessageFrame', 'Log_Error', getglobal('ElronsUI_Log'), w, h)
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
	frame:SetScript('OnEvent', function() Chat:Error_OnEvent(event) end)
	frame:SetScript('OnHyperlinkClick', function() Chat:OnHyperlinkShow(arg1, arg2, arg3) end)
	frame:RegisterEvent('SYSMSG')
	frame:RegisterEvent('ADDON_ACTION_FORBIDDEN')
	frame:RegisterEvent('MACRO_ACTION_BLOCKED')
	frame:RegisterEvent('SCREENSHOT_FAILED')
	frame:RegisterEvent('SCREENSHOT_SUCCEEDED')
	frame:RegisterEvent('UI_ERROR_MESSAGE')
	frame:RegisterEvent('UI_INFO_MESSAGE')
	
	-- Hide frame
	frame:Hide()
end