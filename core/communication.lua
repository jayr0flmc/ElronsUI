local Engine = getglobal('ElronsUI')

function Engine:AddonMsgSend(type, message)
	local prefix = 'ElronsUI'
	
	if(type == 'BATTLEGROUND') then
		if(GetNumRaidMembers() > 0) then
			SendAddonMessage(prefix, message, 'BATTLEGROUND')
		end
	end
	if(type == 'GUILD') then
		if(IsInGuild()) then
			SendAddonMessage(prefix, message, 'GUILD')
		end
	end
	if(type == 'OFFICER') then
		if(IsInGuild()) then
			SendAddonMessage(prefix, message, 'BATTLEGROUND')
		end
	end
	if(type == 'PARTY') then
		if(UnitName('party1') ~= nil) then
			SendAddonMessage(prefix, message, 'PARTY')
		end
	end
	if(type == 'RAID') then
		if(GetNumRaidMembers() > 0) then
			SendAddonMessage(prefix, message, 'BATTLEGROUND')
		end
	end
end

function Engine:AddonMsgReceive(prefix, message, channel, sender)
	local array, cmd
	if(not prefix == 'ElronsUI') then return end
	
	array = self:Explode('#', message)
	cmd = array[1]
	
	if(cmd == 'VersionCheck') then
		local version, dev = array[2], array[3]
		local vArrayRecv = self:Explode('.', version)
		local vArraySelf = self:Explode('.', self.info.version)
		
		if(dev == 'true' and self.DB.db.profile.general.development == false) then return end
		
		if(
			vArrayRecv[1] > vArraySelf[1] or
			vArrayRecv[2] > vArraySelf[2] or
			vArrayRecv[3] > vArraySelf[3] or
			vArrayRecv[4] > vArraySelf[4]
		) then
			self:Debug(format('%s is outdated!', self.info.title), 'warn')
			self:Debug(format('Please upgrade to version [%s].', version), 'info')
			if(dev == 'true') then
				self:Debug('It\'s a dev-version. Please check github.', 'info')
			else
				self:Debug('Check curse for update.', 'info')
			end
			
			self:Debug('Newer version', 'debug')
		end
		
		--[[
		if(
			vArrayRecv[1] < vArraySelf[1] or
			vArrayRecv[2] < vArraySelf[2] or
			vArrayRecv[3] < vArraySelf[3] or
			vArrayRecv[4] < vArraySelf[4]
		) then
			
			
			self:Debug('Older version', 'debug')
		end
		
		if(
			vArrayRecv[1] == vArraySelf[1] or
			vArrayRecv[2] == vArraySelf[2] or
			vArrayRecv[3] == vArraySelf[3] or
			vArrayRecv[4] == vArraySelf[4]
		) then self:Debug('Same version', 'debug') end
		]]--
	end
	
	self:Debug(format('prefix: %s', prefix), 'debug')
	self:Debug(format('message: %s', message), 'debug')
	self:Debug(format('channel: %s', channel), 'debug')
	self:Debug(format('sender: %s', sender), 'debug')
end