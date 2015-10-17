local Engine = getglobal('ElronsUI')
local Chat = Engine:GetModule('Chat')
local Layout = Engine:GetModule('Layout')
local DB

function Chat:LFG_OnEvent(event)
	local output, prefixTime, prefixPlayer
	local h, m = GetGameTime()
	local message, author, language, channelString, target, flags, zoneID, channelID, channelName
	local type, info, channelLength
	
	output = ''
	if(strlen(h) == 1) then h = '0'..h end
	if(strlen(m) == 1) then h = '0'..m end
	prefixTime = '['..h..':'..m..'] '
	prefixPlayer = ''
	
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
		channelLength	= strlen(channelString)
		
		if(strlen(flags) > 0) then prefixPlayer = '<'..strupper(flags)..'>' end
			
		-- Get out all system events.
		-- Fires when a system message is received.
		if(type == 'SYSTEM') then
			output = prefixTime..message
		end
		
		-- Fires when an automatic AFK response is received.
		if(type == 'AFK') then
			output = prefixTime..sender..' is Away From Keyboard: '..message
		end
		-- Fires when an automatic DND response is received.
		if(type == 'DND') then
			output = prefixTime..sender..' does not wish to be disturbed: '..message
		end
		
		-- Fires when an automatic response is received after whispering or inviting a character who is ignoring the player.
		if(type == 'IGNORED') then
			output = prefixTime..sender..' is ignoring you.'
		end
		
		
		
		-- Get out whisper events.
		-- Fires when the player receives a whisper from another player's character.
		if(type == 'WHISPER') then
			output = prefixTime..'|Hplayer:'..sender..'|h['..sender..']|h whispers: '..message
		end
		-- Fires when the player sends a whisper to another player's character.
		if(type == 'WHISPER_INFORM') then
			output = prefixTime..'To |Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		
		
		
		-- Get out the filtered 'CHANNEL' events.
		-- Fires when a message is received in a world or custom chat channel.
		if(type == 'CHANNEL') then
			if(channelName == 'LookingForGroup') then
				output = prefixTime..'['..channelString..'] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
			end
		end
		
		
		
		this:AddMessage(output, info.r, info.g, info.b, info.id)
	end
	
	if(event == 'TIME_PLAYED_MSG') then
		ChatFrame_DisplayTimePlayed(arg1, arg2)
		
		return
	end
end



function Chat:LFG_Init()
	local frame, editBox, header
	local w, h
	
	-- Bring in database
	DB = Engine.DB.db.profile.chat
	
	-- Calculate width and height
	w = (DB.width - 8)
	h = (DB.height - (20 * 2) - 16)
	
	-- Create frame
	frame = Layout:CreateFrame('ScrollingMessageFrame', 'Chat_LFG', getglobal('ElronsUI_Chat'), w, h)
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
	frame:SetScript('OnEvent', function() Chat:LFG_OnEvent(event) end)
	frame:SetScript('OnHyperlinkClick', function() Chat:OnHyperlinkShow(arg1, arg2, arg3) end)
	frame:RegisterEvent('CHAT_MSG_SYSTEM')
	frame:RegisterEvent('CHAT_MSG_AFK')
	frame:RegisterEvent('CHAT_MSG_DND')
	frame:RegisterEvent('CHAT_MSG_IGNORED')
	frame:RegisterEvent('CHAT_MSG_WHISPER')
	frame:RegisterEvent('CHAT_MSG_WHISPER_INFORM')
	frame:RegisterEvent('CHAT_MSG_CHANNEL')
	frame:RegisterEvent('TIME_PLAYED_MSG')
	
	-- Hide frame
	frame:Hide()
end