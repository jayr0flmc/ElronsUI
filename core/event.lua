local Engine = getglobal('ElronsUI')

-- ADDON_LOADED
function Engine:OnAddonLoaded(addon)
	self:Debug(format('Addon loaded [%s].', tostring(addon)), 'debug')
end

-- SPELLS_CHANGED
function Engine:OnSpellsChanged()
	self:Debug('Spells changed.', 'debug')
end

-- PLAYER_LOGIN
function Engine:OnPlayerLogin()
	self:Debug('Player logging in...', 'debug')
	
	self:Initialize()
	
	-- Join custom channel
	--local type, name = JoinChannelByName('ElronsUI')
	--self:Debug(format('type: %s | name: %s', tostring(type), tostring(name)), 'debug')
	
	self:Debug('Player logged in.', 'debug')
end

-- PLAYER_ENTERING_WORLD
function Engine:OnPlayerEnteringWorld()
	self:Debug('Player entering world...', 'debug')
	
	-- Do version check
	local msg = format('VersionCheck#%s#%s', tostring(self.info.version), tostring(self.DB.db.profile.general.development))
	
	self:AddonMsgSend('BATTLEGROUND', msg)
	self:AddonMsgSend('GUILD', msg)
	self:AddonMsgSend('OFFICER', msg)
	self:AddonMsgSend('PARTY', msg)
	self:AddonMsgSend('RAID', msg)
	
	self:Debug('Player entered world.', 'debug')
end

-- PLAYER_ALIVE
function Engine:OnPlayerAlive()
	self:Debug('Player is alive.', 'debug')
	
	
end



function Engine:OnEvent(event)
	if(event == 'ADDON_LOADED') then self:OnAddonLoaded(arg1) end
	if(event == 'SPELLS_CHANGED') then self:OnSpellsChanged() end
	if(event == 'PLAYER_LOGIN') then self:OnPlayerLogin() end
	if(event == 'PLAYER_ENTERING_WORLD') then self:OnPlayerEnteringWorld() end
	if(event == 'PLAYER_ALIVE') then self:OnPlayerAlive() end
	if(event == 'CHAT_MSG_ADDON') then self:AddonMsgReceive(arg1, arg2, arg3, arg4) end
end