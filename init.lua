-- Define bindings header
BINDING_HEADER_ELRONSUI = 'ElronsUI'
--RegisterAddonMessagePrefix('ELRONSUI')

-- Pre-define variables
local AddonInfo	= {}
local Engine	= {}

-- Read out addon info data
AddonInfo.name, AddonInfo.title, AddonInfo.notes = GetAddOnInfo('ElronsUI')
AddonInfo.author, AddonInfo.version = GetAddOnMetadata('ElronsUI', 'Author'), GetAddOnMetadata('ElronsUI', 'Version')
AddonInfo.locale = GetLocale()

-- Bring in Ace2
local Addon		= AceLibrary('AceAddon-2.0'):new('AceConsole-2.0', 'AceEvent-2.0')
local Hook		= AceLibrary('AceHook-2.1')
local DB		= AceLibrary('AceDB-2.0')
local Locale	= AceLibrary('AceLocale-2.2'):new(AddonInfo.name)

-- Prepare engine object
Engine = {
	Addon	= Addon,
	Hook	= Hook,
	DB		= DB,
	Locale	= Locale
}
-- Prepare options variable
Engine.options = {
	type	= 'group',
	name	= AddonName,
	args	= {}
}
Engine.info = AddonInfo
-- Not initialized yet!
Engine.initialized	= false

-- Publish object
setglobal('ElronsUI', Engine)



-- Prepare general frames
local frame = CreateFrame('Frame', 'ElronsUI')
-- Event handling
frame:SetScript('OnEvent', function() Engine:OnEvent(event) end)
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('SPELLS_CHANGED')
frame:RegisterEvent('PLAYER_LOGIN')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:RegisterEvent('PLAYER_ALIVE')
frame:RegisterEvent('CHAT_MSG_ADDON')