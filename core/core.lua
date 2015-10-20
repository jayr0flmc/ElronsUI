local Engine = getglobal('ElronsUI')
Engine.__index = Engine



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
	
	self:Debug('Loading layout...', 'debug')
	if(not self:InitModule('Layout')) then
		error = true
		self:Debug('Error while try to load layout.', 'error')
	else
		self:Debug('Layout loaded.', 'info')
	end
	
	self:Debug('Initializing configuration window...', 'debug')
	if(not self:GetModule('Config'):InitConfigWindow()) then
		error = true
		self:Debug('Error while try to initialize configuration window.', 'error')
	else
		self:Debug('Configuration window initialized.', 'info')
	end
	
	self:Debug('Loading chat...', 'debug')
	if(not self:InitModule('Chat')) then
		error = true
		self:Debug('Error while try to load chat.', 'error')
	else
		self:Debug('Chat loaded.', 'info')
	end
	
	if(error) then
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