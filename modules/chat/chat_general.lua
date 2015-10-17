local Engine = getglobal('ElronsUI')
local Chat = Engine:GetModule('Chat')
local Layout = Engine:GetModule('Layout')
local DB

ChatTypeInfo["OFFICER"]		= { sticky = 1 };
ChatTypeInfo["WHISPER"]		= { sticky = 1 };
ChatTypeInfo["REPLY"]		= { sticky = 1 };
ChatTypeInfo["CHANNEL"]		= { sticky = 1 };
ChatTypeInfo["CHANNEL1"]	= { sticky = 1 };
ChatTypeInfo["CHANNEL2"]	= { sticky = 1 };
ChatTypeInfo["CHANNEL3"]	= { sticky = 1 };
ChatTypeInfo["CHANNEL4"]	= { sticky = 1 };
ChatTypeInfo["CHANNEL5"]	= { sticky = 1 };
ChatTypeInfo["CHANNEL6"]	= { sticky = 1 };
ChatTypeInfo["CHANNEL7"]	= { sticky = 1 };
ChatTypeInfo["CHANNEL8"]	= { sticky = 1 };
ChatTypeInfo["CHANNEL9"]	= { sticky = 1 };
ChatTypeInfo["CHANNEL10"]	= { sticky = 1 };



function Chat:General_OnEvent(event)
	local output, prefixTime, prefixPlayer
	local h, m = GetGameTime()
	local message, author, language, channelString, target, flags, zoneID, channelID, channelName
	local type, info, channelLength
	
	output = ''
	if(strlen(h) == 1) then h = '0'..h end
	if(strlen(m) == 1) then h = '0'..m end
	prefixTime = '['..h..':'..m..'] '
	prefixPlayer = ''
	
	if(event == 'PLAYER_ENTERING_WORLD') then
		this.defaultLanguage = GetDefaultLanguage()
		
		return
	end
	if(event == 'TIME_PLAYED_MSG') then
		ChatFrame_DisplayTimePlayed(arg1, arg2)
		
		return
	end
	if(event == 'ZONE_UNDER_ATTACK') then
		local info = ChatTypeInfo['SYSTEM']
		this:AddMessage(prefixTime..format(TEXT(ZONE_UNDER_ATTACK), arg1), info.r, info.g, info.b, info.id)
		
		return
	end
	if(event == 'GUILD_MOTD') then
		if(arg1 and (strlen(arg1) > 0)) then
			local info = ChatTypeInfo['GUILD']
			local string = format(TEXT(GUILD_MOTD_TEMPLATE), arg1)
			
			this:AddMessage(string, info.r, info.g, info.b, info.id)
		end
		
		return
	end
	if(event == 'EXECUTE_CHAT_LINE') then
		this.editBox:SetText(arg1)
		self:EditBox_SendText(this.editBox)
		self:EditBox_OnEscapePressed(this.editBox)
		
		return
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
		channelLength	= strlen(channelString)
		
		if(strlen(flags) > 0) then prefixPlayer = '<'..strupper(flags)..'>' end
		
		-- Color name like class
		
		
		
		-- Get out all system events
		-- Fires when a system message is received.
		if(type == 'SYSTEM') then
			output = prefixTime..message
		end
		-- 
		if(type == 'RESTRICTED') then
			output = prefixTime..'Trial accounts cannot perform that action.'
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
		
		
		
		-- Get out say, yell, emote and whisper events
		-- Fires when the player or a nearby character speaks (visible to other nearby characters).
		if(type == 'SAY') then
			output = prefixTime..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h says: '..message
		end
		-- Fires when the player or another player character yells (visible to other characters in a wide area).
		if(type == 'YELL') then
			output = prefixTime..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h yells: '..message
		end
		-- Fires when a custom emote message is received.
		if(type == 'EMOTE') then
			output = prefixTime..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h '..message
		end
		-- Fires when the player receives a standard emote (e.g. `/dance`, `/flirt`) message.
		if(type == 'TEXT_EMOTE') then
			output = prefixTime..message
		end
		-- Fires when the player receives a whisper from another player's character.
		if(type == 'WHISPER') then
			output = prefixTime..'|Hplayer:'..sender..'|h['..sender..']|h whispers: '..message
		end
		-- Fires when the player sends a whisper to another player's character.
		if(type == 'WHISPER_INFORM') then
			output = prefixTime..'To |Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		
		
		
		-- Monster/NPC related events
		if(type == 'MONSTER_PARTY') then
			output = message
		end
		if(type == 'MONSTER_EMOTE') then
			output = format(message, sender)
		end
		if(type == 'MONSTER_SAY') then
			output = sender..' says: '..message
		end
		if(type == 'MONSTER_WHISPER') then
			output = sender..' whispers: '..message
		end
		if(type == 'MONSTER_YELL') then
			output = sender..' yells: '..message
		end
		
		if(type == 'RAID_BOSS_EMOTE' or type == 'RAID_BOSS_WHISPER') then
			output = format(message, sender)
		end
		
		
		
		-- Get out all guild depend events
		-- Fires when a message is received in the guild chat channel.
		if(type == 'GUILD') then
			output = prefixTime..'[Guild] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		-- Fires when a message is received in officer chat.
		if(type == 'OFFICER') then
			output = prefixTime..'[Officer] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		
		
		
		-- Get out all party and raid depend events
		-- Fires when a message is received in the party chat channel.
		if(type == 'PARTY') then
			output = prefixTime..'[Party] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		-- Fires when a Party Leader types in chat.
		if(type == 'PARTY_LEADER') then
			output = prefixTime..'[Party Leader] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		
		-- Fires when a message is received in the raid chat channel.
		if(type == 'RAID') then
			output = prefixTime..'[Raid] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		-- Fires when a message is received in the raid chat channel from the raid leader.
		if(type == 'RAID_LEADER') then
			output = prefixTime..'[Raid Leader] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		-- Fires when a raid warning message is received.
		if(type == 'RAID_WARNING') then
			output = prefixTime..'[Raid Warning] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		
		
		
		-- Get out all battleground depend events
		if(type == 'BATTLEGROUND') then
			output = prefixTime..'[Battleground] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		if(type == 'BATTLEGROUND_LEADER') then
			output = prefixTime..'[Battleground Leader] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
		end
		
		-- Fires when an Alliance-related battleground system message is received.
		if(type == 'BG_SYSTEM_ALLIANCE') then
			output = prefixTime..message
		end
		-- Fires when a Horde-related battleground system message is received.
		if(type == 'BG_SYSTEM_HORDE') then
			output = prefixTime..message
		end
		-- Fires when a general battleground, zone or world message is received.
		if(type == 'BG_SYSTEM_NEUTRAL') then
			output = prefixTime..message
		end
		
		
		
		-- Get out the filtered 'CHANNEL' events
		-- Fires when a message is received in a world or custom chat channel.
		if(type == 'CHANNEL') then
			if(channelName ~= 'ZeppelinMaster') then
				output = prefixTime..'['..channelString..'] '..prefixPlayer..'|Hplayer:'..sender..'|h['..sender..']|h: '..message
			end
		end
		-- Fires when another character joins a world or custom chat channel monitored by the player.
		if(type == 'CHANNEL_JOIN') then
			output = prefixTime..'['..channelString..']: |Hplayer:'..sender..'|h['..sender..']|h joined channel.'
		end
		-- Fires when another character leaves a world or custom chat channel monitored by the player.
		if(type == 'CHANNEL_JOIN') then
			output = prefixTime..'['..channelString..']: |Hplayer:'..sender..'|h['..sender..']|h left channel.'
		end
		-- Fires when certain actions happen on a world or custom chat channel.
		if(type == 'CHANNEL_NOTICE') then
			if(tostring(channelID) ~= '0') then
				if(message == 'YOU_JOINED') then output = prefixTime..'Joined Channel: ['..channelString..']' end
				if(message == 'YOU_LEFT') then output = prefixTime..'Left Channel: ['..channelString..']' end
				if(message == 'YOU_CHANGED') then output = prefixTime..'Changed Channel: ['..channelString..']' end
				if(message == 'SUSPENDED') then output = prefixTime..'Left Channel: ['..channelString..']' end
				if(message == 'THROTTLED') then
					output = prefixTime..'['..channelString..'] The number of messages that can be sent to this channel is limited, please wait to send another message.'
				end
			end
		end
		-- Fires when certain actions pertaining to specific members happen on a world or custom chat channel.
		if(type == 'CHANNEL_NOTICE_USER') then
			if(channelName ~= 'ZeppelinMaster') then
				Engine:Debug('-------------------------', 'debug')
				Engine:Debug('event: '..event, 'debug')
				Engine:Debug('arg1: '..arg1, 'debug')
				Engine:Debug('arg2: '..arg2, 'debug')
				Engine:Debug('arg3: '..arg3, 'debug')
				Engine:Debug('arg4: '..arg4, 'debug')
				Engine:Debug('arg5: '..arg5, 'debug')
				Engine:Debug('arg6: '..arg6, 'debug')
				Engine:Debug('arg7: '..arg7, 'debug')
				Engine:Debug('arg8: '..arg8, 'debug')
				Engine:Debug('arg9: '..arg9, 'debug')
				Engine:Debug('arg10: '..arg10, 'debug')
				Engine:Debug('-------------------------', 'debug')
			end
		end
		
		
		
		this:AddMessage(output, info.r, info.g, info.b, info.id)
		
		return
	end
end
function Chat:General_OnUpdate(elapsedSec)
	if(not this:IsVisible()) then return end
end



function Chat:EditBox_OnShow()
	if(this.chatType == 'PARTY' and UnitName('party1') == '') then this.chatType = 'SAY' end
	if(this.chatType == 'RAID' and (GetNumRaidMembers() == 0)) then this.chatType = 'SAY' end
	if((this.chatType == 'GUILD' or this.chatType == 'OFFICER') and not IsInGuild()) then this.chatType = 'SAY' end
	if(this.chatType == 'BATTLEGROUND' and (GetNumRaidMembers() == 0)) then this.chatType = 'SAY' end
	
	this.tabCompleteIndex = 1
	this.tabCompleteText = nil
	
	self:EditBox_UpdateHeader(this)
	
	this:SetFocus()
end
function Chat:EditBox_OnUpdate(elapsedSec)
	if(this.setText == true) then
		this:SetText(this.text)
		this.setText = false
		
		self:EditBox_ParseText(this, false)
	end
end
function Chat:EditBox_OnEnterPressed()
	self:EditBox_SendText(this, true)
	
	if(ChatTypeInfo[this.chatType].sticky == 1) then this.stickyType = this.chatType end
	
	-- Simualte escape keypress
	self:EditBox_OnEscapePressed(this)
end
function Chat:EditBox_OnEscapePressed(editBox)
	editBox.chatType = this.stickyType
	editBox:SetText('')
	editBox:Hide()
end
function Chat:EditBox_OnSpacePressed()
	self:EditBox_ParseText(this, false)
end
function Chat:EditBox_OnTabPressed()
	if(this.chatType == 'WHISPER') then
		local target = self:EditBox_GetNextTellTarget(this, this.tellTarget)
		
		if(target and (strlen(target) > 0)) then
			this.tellTarget = target
			self:EditBox_UpdateHeader(this)
		end
		
		return
	end
	
	local text = this.tabCompleteText
	if(not text) then
		text = this:GetText()
		this.tabCompleteText = text
	end
	
	if(strsub(text, 1, 1) ~= '/') then return end
	
	-- Increment the current tabcomplete count
	local tabCompleteIndex = this.tabCompleteIndex
	this.tabCompleteIndex = tabCompleteIndex + 1
	
	-- If the string is in the format "/cmd blah", command will be "cmd"
	local cmd = gsub(text, '/([^%s]+)%s(.*)', '/%1', 1)
	
	for idx, val in ChatTypeInfo do
		local i = 1
		local cmdString = TEXT(getglobal('SLASH_'..idx..i))
		
		while(cmdString) do
			if(strfind(cmdString, cmd, 1, 1)) then
				tabCompleteIndex = tabCompleteIndex - 1
				
				if(tabCompleteIndex == 0) then
					this.ignoreTextChange = 1
					this:SetText(cmdString)
					
					return
				end
			end
			
			i = i + 1
			cmdString = TEXT(getglobal('SLASH_'..idx..i))
		end
	end
	
	for idx, val in SlashCmdList do
		local i = 1
		local cmdString = TEXT(getglobal('SLASH_'..idx..i))
		
		while(cmdString) do
			if(strfind(cmdString, cmd, 1, 1)) then
				tabCompleteIndex = tabCompleteIndex - 1
				
				if(tabCompleteIndex == 0) then
					this.ignoreTextChange = 1
					this:SetText(cmdString)
					
					return
				end
			end
			
			i = i + 1
			cmdString = TEXT(getglobal('SLASH_'..idx..i))
		end
	end
	
	local i = 1
	local j = 1
	local cmdString = TEXT(getglobal('EMOTE'..i..'_CMD'..j))
	while(cmdString) do
		if(strfind(cmdString, cmd, 1, 1)) then
			tabCompleteIndex = tabCompleteIndex - 1
			
			if(tabCompleteIndex == 0) then
				this.ignoreTextChange = 1
				this:SetText(cmdString)
				
				return
			end
		end
		
		j = j + 1
		cmdString = TEXT(getglobal('EMOTE'..i..'_CMD'..j))
		if(not cmdString) then
			i = i + 1
			j = 1
			cmdString = TEXT(getglobal('EMOTE'..i..'_CMD'..j))
		end
	end
	
	-- No tab completion
	this:SetText(this.tabCompleteText)
end
function Chat:EditBox_OnTextChanged()
	if(not this.ignoreTextChange) then
		this.tabCompleteIndex = 1
		this.tabCompleteText = nil
	end
	
	this.ignoreTextChange = nil
end
function Chat:EditBox_OnTextSet()
	self:EditBox_ParseText(this, false)
end

function Chat:EditBox_UpdateHeader(editBox)
	local type, info, header
	
	type = this.chatType
	if(not type) then return end
	
	info = ChatTypeInfo[this.chatType]
	header = editBox.header
	if(not header) then return end
	
	if(type == 'WHISPER') then
		header:SetText(format(TEXT(getglobal('CHAT_WHISPER_SEND')), this.tellTarget))
	elseif(type == 'EMOTE') then
		header:SetText(format(TEXT(getglobal('CHAT_EMOTE_SEND')), UnitName('player')))
	elseif(type == 'CHANNEL') then
		local channel, channelName, instanceID = GetChannelName(this.channelTarget)
		
		if(channelName) then
			if(instanceID > 0) then channelName = channelName..' '..instanceID end
			info = ChatTypeInfo['CHANNEL'..channel]
			this.channelTarget = channel
			header:SetText(format(TEXT(getglobal('CHAT_CHANNEL_SEND')), channel, channelName))
		end
	else
		header:SetText(TEXT(getglobal('CHAT_'..type..'_SEND')))
	end
	
	header:SetTextColor(info.r, info.g, info.b)
	this:SetTextColor(info.r, info.g, info.b)
	
	-- Adjust header
	header:SetWidth(header:GetStringWidth())
	this:SetTextInsets(header:GetStringWidth() + 4, 0, 0, 0)
end

function Chat:EditBox_ParseText(editBox, send)
	local text = editBox:GetText()
	if(strlen(text) <= 0) then return end
	if(strsub(text, 1, 1) ~= '/') then return end
	
	-- If the string is in the format "/cmd blah", command will be "cmd"
	local cmd = gsub(text, '/([^%s]+)%s(.*)', '/%1', 1)
	local msg = ''
	if(cmd ~= text) then msg = strsub(text, strlen(cmd) + 2) end
	cmd = gsub(cmd, '%s+', '')
	cmd = strupper(cmd)
	
	
	
	local channel = gsub(cmd, '/([0-9]+)', '%1')
	if(strlen(channel) > 0 and channel >= '0' and channel <= '9') then
		local channelNum, channelName = GetChannelName(channel)
		
		
	else
		for idx, val in ChatTypeInfo do
			local i = 1
			local cmdString = TEXT(getglobal('SLASH_'..idx..i))
			
			while(cmdString) do
				cmdString = strupper(cmdString)
				
				if(cmdString == cmd) then
					if(idx == 'WHISPER') then
						self:EditBox_ExtractTellTarget(editBox, msg)
					elseif(idx == 'REPLY') then
						local lastTell = self:EditBox_GetLastTellTarget(editBox)
						
						if(strlen(lastTell) > 0) then
							editBox.chatType = 'WHISPER'
							editBox.tellTarget = lastTell
							editBox:SetText(msg)
							self:EditBox_UpdateHeader(editBox)
						else
							if(send == true) then self:EditBox_OnEscapePressed(editBox) end
							
							return
						end
					elseif(idx == 'CHANNEL') then
						self:EditBox_ExtractChannel(editBox, msg)
					else
						editBox.chatType = idx
						editBox:SetText(msg)
						self:EditBox_UpdateHeader(editBox)
					end
					
					return
				end
				
				i = i + 1
				cmdString = TEXT(getglobal('SLASH_'..idx..i))
			end
		end
	end
	
	if(send == false) then return end
	
	
	
	for idx, val in SlashCmdList do
		local i = 1
		local cmdString = TEXT(getglobal('SLASH_'..idx..i))
		
		while(cmdString) do
			cmdString = strupper(cmdString)
			
			if(cmdString == cmd) then
				val(msg)
				editBox:AddHistoryLine(text)
				self:EditBox_OnEscapePressed(editBox)
				
				return
			end
			
			i = i + 1
			cmdString = TEXT(getglobal('SLASH_'..idx..i))
		end
	end
	
	local i = 1
	local j = 1
	local cmdString = TEXT(getglobal('EMOTE'..i..'_CMD'..j))
	while(cmdString) do
		if(strupper(cmdString) == cmd) then
			local token = getglobal('EMOTE'..i..'_TOKEN')
			
			if(token) then DoEmote(token, msg) end
			editBox:AddHistoryLine(text)
			self:EditBox_OnEscapePressed(editBox)
			
			return
		end
		
		j = j + 1
		cmdString = TEXT(getglobal('EMOTE'..i..'_CMD'..j))
		if(not cmdString) then
			i = i + 1
			j = 1
			cmdString = TEXT(getglobal('EMOTE'..i..'_CMD'..j))
		end
	end
	
	
	
	-- Unrecognized chat command, show simple help text
	local info = ChatTypeInfo['SYSTEM']
	Engine:Debug(format('rgbid: %s %s %s %s', info.r, info.g, info.b, info.id), 'debug')
	editBox.chatFrame:AddMessage(TEXT(HELP_TEXT_SIMPLE), info.r, info.g, info.b, info.id)
	self:EditBox_OnEscapePressed(editBox)
	return
end
function Chat:EditBox_SendText(editBox, addHistory)
	local type, text
	self:EditBox_ParseText(editBox, true)
	
	type = editBox.chatType
	text = editBox:GetText()
	
	if(strlen(gsub(text, '%s*(.*)', '%1')) > 0) then
		if(type == 'WHISPER') then
			if(strlen(text) > 0) then self:EditBox_SetLastToldTarget(editBox, editBox.tellTarget) end
			
			SendChatMessage(text, type, editBox.language, editBox.tellTarget)
		elseif(type == 'CHANNEL') then
			SendChatMessage(text, type, editBox.language, editBox.channelTarget)
		else
			SendChatMessage(text, type, editBox.language)
		end
		
		--if(addHistory) then self:EditBox_AddHistory(editBox) end
	end
end

function Chat:EditBox_GetLastTellTarget(editBox)
	for idx, val in editBox.lastTell do
		if(val and (strlen(val) > 0)) then return val end
	end
	
	return ''
end
function Chat:EditBox_GetNextTellTarget(editBox, target)
	if(not target or (strlen(target) == 0)) then return editBox.lastTell[1] end
	
	for i = 1, NUM_REMEMBERED_TELLS - 1, 1 do
		if(strlen(editBox.lastTell[i]) == 0) then
			break
		elseif(strupper(target) == strupper(editBox.lastTell[i])) then
			if(strlen(editBox.lastTell[i + 1]) > 0) then
				return editBox.lastTell[i + 1]
			else
				break
			end
		end
	end
	
	return editBox.lastTell[1]
end
function Chat:EditBox_SetLastTellTarget(editBox, target)
	local found = NUM_REMEMBERED_TELLS
	
	for idx, val in editBox.lastTell do
		if(strupper(target) == strupper(val)) then
			found = idx
			
			break
		end
	end
	
	for i = found, 2, -1 do
		editBox.lastTell[i] = editBox.lastTell[i - 1]
	end
	
	editBox.lastTell[1] = target
end

function Chat:EditBox_GetLastToldTarget(editBox)
	local told = editBox.toldTarget
	
	if(not (lastTold == nil)) then return told end
	
	return ''
end
function Chat:EditBox_SetLastToldTarget(editBox, name)
	editBox.toldTarget = name
end

function Chat:EditBox_ExtractTellTarget(editBox, msg)
	-- Grab first "word" in the string
	local target = gsub(msg, '(%s*)([^%s]+)(.*)', '%2', 1)
	if((strlen(target) <= 0) or (strsub(target, 1, 1) == '|')) then return end
	
	msg = strsub(msg, strlen(target) + 2)
	
	editBox.tellTarget = target
	editBox.chatType = 'WHISPER'
	editBox:SetText(msg)
	self:EditBox_UpdateHeader(editBox)
end
function Chat:EditBox_ExtractChannel(editBox, msg)
	local target = gsub(msg, '(%s*)([^%s]+)(.*)', '%2', 1)
	if((strlen(target) <= 0) or (strsub(target, 1, 1) == '|')) then return end
	
	local channelNum, channelName = GetChannelName(target)
	if(channelNum <= 0) then return end
	
	msg = strsub(msg, strlen(target) + 2)
	
	editBox.channelTarget = channelNum
	editBox.chatType = 'CHANNEL'
	editBox:SetText(msg)
	self:EditBox_UpdateHeader(editBox)
end



function Chat:General_Init()
	local frame, editBox, header
	local w, h
	
	-- Bring in database
	DB = Engine.DB.db.profile.chat
	
	-- Calculate width and height
	w = (DB.width - 8)
	h = (DB.height - (20 * 2) - 16)
	
	-- Create frame
	frame = Layout:CreateFrame('ScrollingMessageFrame', 'Chat_General', getglobal('ElronsUI_Chat'), w, h)
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
	frame:SetScript('OnEvent', function() Chat:General_OnEvent(event) end)
	frame:SetScript('OnUpdate', function() Chat:General_OnUpdate(arg1) end)
	frame:SetScript('OnHyperlinkClick', function() Chat:OnHyperlinkShow(arg1, arg2, arg3) end)
	frame:RegisterEvent('PLAYER_ENTERING_WORLD')
	frame:RegisterEvent('TIME_PLAYED_MSG')
	frame:RegisterEvent('ZONE_UNDER_ATTACK')
	frame:RegisterEvent('UPDATE_INSTANCE_INFO')
	frame:RegisterEvent('GUILD_MOTD')
	frame:RegisterEvent('EXECUTE_CHAT_LINE')
	frame:RegisterEvent('CHAT_MSG_AFK')
	frame:RegisterEvent('CHAT_MSG_BATTLEGROUND')
	frame:RegisterEvent('CHAT_MSG_BATTLEGROUND_LEADER')
	frame:RegisterEvent('CHAT_MSG_BG_SYSTEM_ALLIANCE')
	frame:RegisterEvent('CHAT_MSG_BG_SYSTEM_HORDE')
	frame:RegisterEvent('CHAT_MSG_BG_SYSTEM_NEUTRAL')
	frame:RegisterEvent('CHAT_MSG_CHANNEL')
	frame:RegisterEvent('CHAT_MSG_CHANNEL_JOIN')
	frame:RegisterEvent('CHAT_MSG_CHANNEL_LEAVE')
	frame:RegisterEvent('CHAT_MSG_CHANNEL_LIST')
	frame:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE')
	frame:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE_USER')
	frame:RegisterEvent('CHAT_MSG_DND')
	frame:RegisterEvent('CHAT_MSG_EMOTE')
	frame:RegisterEvent('CHAT_MSG_GUILD')
	frame:RegisterEvent('CHAT_MSG_IGNORED')
	frame:RegisterEvent('CHAT_MSG_MONSTER_EMOTE')
	frame:RegisterEvent('CHAT_MSG_MONSTER_SAY')
	frame:RegisterEvent('CHAT_MSG_MONSTER_WHISPER')
	frame:RegisterEvent('CHAT_MSG_MONSTER_PARTY')
	frame:RegisterEvent('CHAT_MSG_MONSTER_YELL')
	frame:RegisterEvent('CHAT_MSG_OFFICER')
	frame:RegisterEvent('CHAT_MSG_PARTY')
	frame:RegisterEvent('CHAT_MSG_PARTY_LEADER')
	frame:RegisterEvent('CHAT_MSG_RAID')
	frame:RegisterEvent('CHAT_MSG_RAID_BOSS_EMOTE')
	frame:RegisterEvent('CHAT_MSG_RAID_BOSS_WHISPER')
	frame:RegisterEvent('CHAT_MSG_RAID_LEADER')
	frame:RegisterEvent('CHAT_MSG_WARNING')
	frame:RegisterEvent('CHAT_MSG_RESTRICTED')
	frame:RegisterEvent('CHAT_MSG_SAY')
	frame:RegisterEvent('CHAT_MSG_SYSTEM')
	frame:RegisterEvent('CHAT_MSG_TEXT_EMOTE')
	frame:RegisterEvent('CHAT_MSG_WHISPER')
	frame:RegisterEvent('CHAT_MSG_WHISPER_INFORM')
	frame:RegisterEvent('CHAT_MSG_YELL')
	
	-- Setup important variables
	frame.tellTimer			= GetTime()
	frame.channelList		= {}
	frame.zoneChannelList	= {}
	frame.messageTypeList	= {}
	
	
	
	-- Setup EditBox
	h = DB.editBox.height
	-- Create editBox
	editBox = Layout:CreateFrame('EditBox', 'Chat_EditBox', getglobal('ElronsUI_Chat'), w, h)
	-- Set strata and level
	editBox:SetFrameStrata('DIALOG')
	editBox:SetFrameLevel(1)
	-- Set position
	local point, parent = 'BOTTOM', getglobal('ElronsUI_Chat_BarBot')
	if(DB.editBox.position == 'TOP') then
		point = 'TOP'
		parent = getglobal('ElronsUI_Chat_BarTop')
	end
	editBox:SetPoint(point, parent, point, 0, 0)
	-- Set font settings
	editBox:SetFontObject(DB.editBox.font)
	editBox:SetTextColor(DB.editBox.color.r, DB.editBox.color.g, DB.editBox.color.b, DB.editBox.color.a)
	editBox:SetJustifyH(DB.editBox.justifyH)
	-- Hide editBox
	editBox:Hide()
	
	-- Header layer
	header = editBox:CreateFontString(editBox:GetName()..'_Header')
	header:SetHeight(h)
	header:SetPoint('LEFT', editBox, 'LEFT', 0, 0)
	-- Font settings
	header:SetFontObject(DB.editBox.font)
	header:SetTextColor(DB.editBox.color.r, DB.editBox.color.g, DB.editBox.color.b, DB.editBox.color.a)
	header:SetJustifyH(DB.editBox.justifyH)
	-- Save as variable
	editBox.header = header
	
	-- Setup a few very important settings
	editBox.chatType		= 'SAY'
	editBox.stickyType		= 'SAY'
	editBox.lastTell		= {}
	editBox.ChatLanguage	= GetDefaultLanguage()
	
	for i = 1, NUM_REMEMBERED_TELLS, 1 do
		editBox.lastTell[i] = ''
	end
	
	-- Event handling
	editBox:SetScript('OnShow', function() Chat:EditBox_OnShow() end)
	editBox:SetScript('OnUpdate', function() Chat:EditBox_OnUpdate(arg1) end)
	editBox:SetScript('OnEnterPressed', function() Chat:EditBox_OnEnterPressed() end)
	editBox:SetScript('OnEscapePressed', function() Chat:EditBox_OnEscapePressed(this) end)
	editBox:SetScript('OnSpacePressed', function() Chat:EditBox_OnSpacePressed() end)
	editBox:SetScript('OnTabPressed', function() Chat:EditBox_OnTabPressed() end)
	editBox:SetScript('OnTextChanged', function() Chat:EditBox_OnTextChanged() end)
	editBox:SetScript('OnTextSet', function() Chat:EditBox_OnTextSet() end)
	
	
	
	-- Register frame as DEFAULT_CHAT_FRAME
	local oFrame = DEFAULT_CHAT_FRAME
	DEFAULT_CHAT_FRAME = frame
	SELECTED_CHAT_FRAME = frame
	SELECTED_DOCK_FRAME = frame
	frame.editBox = editBox
	editBox.chatFrame = DEFAULT_CHAT_FRAME
	
	-- Prepare the frame after registering and hooking
	frame:Clear()
	frame:AddMessage('---------------------------------------------------------------------------', 1, 1, 1, 0)
	frame:AddMessage(format('%s v%s', Engine.info.title, Engine.info.version), 1, 1, 1, 0)
	frame:AddMessage('', 1, 1, 1, 0)
	frame:AddMessage(' Developer: Elron MacBong a.k.a. JAYMC', 1, 1, 1, 0)
	frame:AddMessage('---------------------------------------------------------------------------\n', 1, 1, 1, 0)
	--Engine.Chat.Chat.General:AddMessage(Engine.Locale['LOGIN_MSG'], 1, 1, 1, 0)
	
	-- Hide away blizzard
	if(Engine.DB.db.profile.general.debug == false) then
		ChatFrameEditBox:Hide()
		ChatFrameEditBox.Show = function() end
		
		ChatFrameMenuButton:Hide()
		ChatFrameMenuButton.Show = function() end
		
		for i = 1, NUM_CHAT_WINDOWS do
			local frame = getglobal('ChatFrame'..i)
			frame:Hide()
			frame.Show = function() end
			
			frame = getglobal('ChatFrame'..i)
			frame:Hide()
			frame.Show = function() end
			
			frame = getglobal('ChatFrame'..i..'Tab')
			frame:Hide()
			frame.Show = function() end
			
			frame = getglobal('ChatFrame'..i..'UpButton')
			frame:Hide()
			frame.Show = function() end
			
			frame = getglobal('ChatFrame'..i..'DownButton')
			frame:Hide()
			frame.Show = function() end
			
			frame = getglobal('ChatFrame'..i..'BottomButton')
			frame:Hide()
			frame.Show = function() end
		end
		oFrame:UnregisterAllEvents()
	end
end