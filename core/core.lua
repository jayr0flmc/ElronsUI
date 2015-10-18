local Engine = getglobal('ElronsUI')
Engine.__index = Engine

-- General needed modules
local modules = {
	'Layout',
	'Chat'
}



-- This frames everything in ElronsUI
Engine.UIParent = UIParent
-- Hiding helper frame
Engine.HiddenFrame = CreateFrame('Frame', 'ElronsUI_HiddenFrame')
Engine.HiddenFrame:Hide()



local function Disable()
	Engine:Debug(format('Try to disable %s...', Engine.info.title), 'info')
	if(DisableAddOn(Engine.info.name)) then
		Engine:Debug(format('%s successfully disabled.', Engine.info.title), 'info')
	else
		Engine:Debug(format('Can\'t disable %s!', Engine.info.title), 'crit')
	end
end



-- General event handler
function Engine:OnEvent(event)
end

function Engine:OnAddonLoaded(addon)
	self:Debug(format('Addon loaded [%s].', tostring(addon)), 'debug')
end

function Engine:OnSpellsChanged()
	self:Debug('Spells changed.', 'debug')
end

function Engine:OnPlayerLogin()
	self:Debug('Player logging in...', 'debug')
	
	self:Initialize()
	
	-- Join custom channel
	--local type, name = JoinChannelByName('ElronsUI')
	--self:Debug(format('type: %s | name: %s', tostring(type), tostring(name)), 'debug')
	
	self:Debug('Player logged in.', 'debug')
end

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

function Engine:OnPlayerAlive()
	self:Debug('Player is alive.', 'debug')
	
	
end



-- Initialize the engine
function Engine:Initialize()
	self:Debug(format('Initializing %s...', self.info.title), 'info')
	
	self:Debug('Reading out general player data...', 'debug')
	self.Player = {
		Realm	= GetRealmName(),
		
		Char	= {
			Name	= UnitName('player'),
			Level	= UnitLevel('player'),
			Sex		= UnitSex('player'),
			Class	= UnitClass('player'),
			Race	= UnitRace('player'),
			Faction	= UnitFactionGroup('player')
		},
		
		PVP		= {
			IsPVP	= UnitIsPVP('player'),
			IsFFA	= UnitIsPVPFreeForAll('player'),
			Name	= UnitPVPName('player'),
			Rank	= UnitPVPRank('player')
		}
	}
	self:Debug('Player data collected.', 'info')
	
	self:Debug('Reading out general game details...', 'debug')
	self.Resolution		= GetCVar('gxResolution')
	self.ScreenWidth	= self:Explode('x', Engine.Resolution)[1]
	self.ScreenHeight	= self:Explode('x', Engine.Resolution)[2]
	self:Debug('General game details collected.', 'info')
	
	
	
	local error = false
	
	self:Debug('Loading config and database...', 'debug')
	if(not self:InitModule('Config')) then
		error = true
		self:Debug('Error while try to load config and database.', 'error')
	else
		self:Debug('Configuration and database loaded.', 'info')
	end
	-- Set debug
	DEBUG_INFO = self.DB.db.profile.debug.info
	DEBUG_DEBUG = self.DB.db.profile.debug.debug
	DEBUG_WARN = self.DB.db.profile.debug.warn
	DEBUG_ERROR = self.DB.db.profile.debug.error
	DEBUG_CRIT = self.DB.db.profile.debug.crit
	
	self:Debug('Loading commands...', 'debug')
	self:LoadCommands()
	self:Debug('Commands loaded.', 'info')
	
	
	
	if(error or self:InitModules(modules)) then
		self:Debug('Unable to initialize all general needed modules!', 'crit')
		self:Debug(format('%s will be disabled now.', self.info.title), 'info')
		--Disable()
		
		return
	end
	self:Debug('Successfully initialized all general needed modules...', 'debug')
	self:Debug('General modules initialized.', 'info')
	
	
	
	self:Debug('Initializing all user modules...', 'info')
	if(self:InitModules(self.DB.db.profile.modules.enabled)) then
		self:Debug('Unable to initialize all user modules!', 'error')
		
		return
	end
	self:Debug('User modules successfully initialized.', 'info')
	
	
	
	self.initialized = true
	self:Debug('Engine successfully initialized.', 'info')
	
	self.DB.db.profile.general.firstLaunch = false
end