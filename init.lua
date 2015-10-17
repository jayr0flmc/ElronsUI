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
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('SPELLS_CHANGED')
frame:RegisterEvent('PLAYER_LOGIN')
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:RegisterEvent('PLAYER_ALIVE')
frame:RegisterEvent('CHAT_MSG_ADDON')
frame:SetScript('OnEvent', function()
	if(event == 'ADDON_LOADED') then Engine:OnAddonLoaded(arg1) end
	if(event == 'SPELLS_CHANGED') then Engine:OnSpellsChanged() end
	if(event == 'PLAYER_LOGIN') then Engine:OnPlayerLogin() end
	if(event == 'PLAYER_ENTERING_WORLD') then Engine:OnPlayerEnteringWorld() end
	if(event == 'PLAYER_ALIVE') then Engine:OnPlayerAlive() end
	if(event == 'CHAT_MSG_ADDON') then Engine:AddonMsgReceive(arg1, arg2, arg3, arg4) end
end)




--[[
local frame = CreateFrame('Frame')
frame:RegisterEvent('ADDON_LOADED')
frame:RegisterEvent('PLAYER_LOGIN')
frame:SetScript('OnEvent', function()
	if(event == 'ADDON_LOADED' and arg1 == 'ElronsUI') then Engine:OnAddOnLoaded() end
	if(event == 'PLAYER_LOGIN') then Engine:Initialize() end
end)
]]--