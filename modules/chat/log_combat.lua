-- Dependencies
local Engine = getglobal('ElronsUI')
local Layout = Engine:GetModule('Layout')
local Chat = Engine:GetModule('Chat')
local DB

-- Register variables

-- External functions

-- Internal functions



-- Class functions
function Chat:Combat_OnEvent(event)
	local output, prefixTime, prefixPlayer
	local h, m = GetGameTime()
	local message, author, language, channelString, target, flags, zoneID, channelID, channelName
	local type, info, channelLength
	
	output = ''
	if(strlen(h) == 1) then h = '0'..h end
	if(strlen(m) == 1) then h = '0'..m end
	prefixTime = '['..h..':'..m..'] '
	prefixPlayer = ''
	
	--[[
	if(
		event ~= 'PLAYER_ENTERING_WORLD' or
		event ~= 'MINIMAP_UPDATE_ZOOM' or
		event ~= 'UPDATE_BONUS_ACTIONBAR' or
		event ~= 'UPDATE_INVENTORY_ALERTS' or
		event ~= 'BAG_UPDATE' or
		event ~= 'QUEST_LOG_UPDATE' or
		event ~= 'PET_BAR_UPDATE' or
		event ~= 'UPDATE_FACTION' or
		event ~= 'UPDATE_LFG_TYPES'
	) then
		Engine:Debug('Event: '..event, 'debug')
	end
	]]--
	
	if(event == 'CHAT_MSG_TARGETICONS') then
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
	if(event == 'CHAT_MSG_TRADESKILLS') then
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
		
		if(strsub(type, 1, 3) == 'BG_') then
			type = strsub(type, 4)
			
			if(type == 'SYSTEM_ALLIANCE' or type == 'SYSTEM_HORDE' or type == 'SYSTEM_NEUTRAL') then
				body = prefixTime..'[BG]: '..message
			end
		end
		
		if(strsub(type, 1, 7) == 'COMBAT_') then
			type = strsub(type, 8)
			
			-- Fires when player's faction changes. i.e.: "Your reputation with Timbermaw Hold has very slightly increased." -- NEW 1.9 
			-- Fired when the player gains any amount of honor, anything from an honorable kill to bonus honor awarded.
			if(type == 'FACTION_CHANGE' or type == 'HONOR_GAIN') then body = prefixTime..message end
			
			-- Fires when your equipment takes durability loss from death, and likely other situations as well.
			-- (no longer fires on reputation changes as of 1.9) 
			if(type == 'MISC_INFO') then body = prefixTime..message end
			
			-- Fired when you gain XP from killing a creature or finishing a quest. Does not fire if you gain no xp from killing a creature.
			if(type == 'XP_GAIN') then body = prefixTime..message end
			
			if(type == 'LOG_ERROR') then body = prefixTime..message end
			if(type == 'LOG_MISC_INFO') then body = prefixTime..message end
			
			
			if(strsub(type, 1, 4) == 'SELF') then body = prefixTime..message end
			if(strsub(type, 1, 3) == 'PET') then body = prefixTime..message end
			if(type == 'FRIENDLY_DEATH') then body = prefixTime..message end
			if(strsub(type, 1, 13) == 'HOSTILEPLAYER' or strsub(type, 1, 14) == 'FRIENDLYPLAYER') then body = prefixTime..message end
			
			if(strsub(type, 1, 8) == 'CREATURE') then body = prefixTime..message end
			if(type == 'HOSTILE_DEATH') then body = prefixTime..message end
			
			if(strsub(type, 1, 5) == 'PARTY') then body = prefixTime..message end
		end
		
		if(strsub(type, 1, 6) == 'SPELL_') then
			body = prefixTime..message
		end
		
		if(info ~= nil) then
			this:AddMessage(body, info.r, info.g, info.b, info.id)
		else
			this:AddMessage(body, 1, 1, 1, 1)
		end
	end
end



-- Initialize
function Chat:Combat_Init()
	local frame
	local w, h
	
	-- Bring in database
	DB = Engine.DB.db.profile.chat
	
	-- Calculate width and height
	w = (DB.width - 8)
	h = (DB.height - (20 * 2) - 16)
	
	-- Create frame
	frame = Layout:CreateFrame('ScrollingMessageFrame', 'Log_Combat', getglobal('ElronsUI_Log'), w, h)
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
	frame:SetScript('OnEvent', function() Chat:Combat_OnEvent(event) end)
	frame:SetScript('OnHyperlinkClick', function() Chat:OnHyperlinkShow(arg1, arg2, arg3) end)
	frame:RegisterEvent('COMBAT_TEXT_UPDATE')
	frame:RegisterEvent('CHAT_MSG_BG_SYSTEM_ALLIANCE')
	frame:RegisterEvent('CHAT_MSG_BG_SYSTEM_HORDE')
	frame:RegisterEvent('CHAT_MSG_BG_SYSTEM_NEUTRAL')
	frame:RegisterEvent('CHAT_MSG_TARGETICONS')
	frame:RegisterEvent('CHAT_MSG_TRADESKILLS')
	frame:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS')
	frame:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES')
	frame:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS')
	frame:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES')
	frame:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS')
	frame:RegisterEvent('CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES')
	frame:RegisterEvent('CHAT_MSG_COMBAT_FACTION_CHANGE')
	frame:RegisterEvent('CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS')
	frame:RegisterEvent('CHAT_MSG_COMBAT_FRIENDLYPLAYER_MISSES')
	frame:RegisterEvent('CHAT_MSG_COMBAT_FRIENDLY_DEATH')
	frame:RegisterEvent('CHAT_MSG_COMBAT_HONOR_GAIN')
	frame:RegisterEvent('CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS')
	frame:RegisterEvent('CHAT_MSG_COMBAT_HOSTILEPLAYER_MISSES')
	frame:RegisterEvent('CHAT_MSG_COMBAT_HOSTILE_DEATH')
	frame:RegisterEvent('CHAT_MSG_COMBAT_LOG_ERROR')
	frame:RegisterEvent('CHAT_MSG_COMBAT_LOG_MISC_INFO')
	frame:RegisterEvent('CHAT_MSG_COMBAT_MISC_INFO')
	frame:RegisterEvent('CHAT_MSG_COMBAT_PARTY_HITS')
	frame:RegisterEvent('CHAT_MSG_COMBAT_PARTY_MISSES')
	frame:RegisterEvent('CHAT_MSG_COMBAT_PET_HITS')
	frame:RegisterEvent('CHAT_MSG_COMBAT_PET_MISSES')
	frame:RegisterEvent('CHAT_MSG_COMBAT_SELF_HITS')
	frame:RegisterEvent('CHAT_MSG_COMBAT_SELF_MISSES')
	frame:RegisterEvent('CHAT_MSG_COMBAT_XP_GAIN')
	
	-- Show frame
	frame:Show()
end