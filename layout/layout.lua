local Engine = getglobal('ElronsUI')
local Layout = Engine:NewModule('Layout')
local DB

function Layout:CreateWindow(name, parent, width, height, strata, level)
	local frame
	local strata	= strata or nil
	local level		= level or nil
	
	frame = self:CreateFrame('Frame', name, parent, width, height, true, strata, level)
	
	return frame
end

function Layout:CreateButton(name, parent, width, height, strata, level)
	local button
	local strata	= strata or nil
	local level		= level or nil
	
	button = self:CreateFrame('Button', name, parent, width, height, true, strata, level)
	
	return button
end

function Layout:CreateStatusBar(name, parent, width, height, strata, level)
	local bar
	local strata	= strata or nil
	local level		= level or nil
	
	bar = self:CreateFrame('StatusBar', name, parent, width, height, true, strata, level)
	
	return bar
end



-- Create a new frame
function Layout:CreateFrame(type, name, parent, width, height, backdrop, strata, level)
	local frame
	local backdrop	= backdrop or false
	local strata	= strata or 'BACKGROUND'
	local level		= level or 0
	nameFull = 'ElronsUI_'..name
	
	-- Create frame
	frame = CreateFrame(type, nameFull, parent)
	-- Set width and height
	frame:SetWidth(width)
	frame:SetHeight(height)
	-- Set strata and level
	frame:SetFrameStrata(strata)
	frame:SetFrameLevel(level)
	-- Set center of screen
	frame:SetPoint('CENTER', parent, 'CENTER', 0, 0)
	-- Set backdrop and edges
	if(backdrop == true) then
		self:SetBackdrop(frame, type)
	end
	
	-- Set variables
	frame.name		= name
	frame.locked	= true
	frame.protected	= false
	
	-- Return frame
	return frame
end

-- Set backdrop and edges
function Layout:SetBackdrop(frame, type)
	local type = type or ''
	
	if(type == 'Frame') then
		frame:SetBackdrop({
			bgFile		= DB.frame.backdrop.bgFile,
			edgeFile	= DB.frame.backdrop.edgeFile,
			tile		= DB.frame.backdrop.tile,
			tileSize	= DB.frame.backdrop.tileSize,
			edgeSize	= DB.frame.backdrop.edgeSize,
			insets		= DB.frame.backdrop.insets
		})
		frame:SetBackdropColor(DB.frame.backdrop.color.r, DB.frame.backdrop.color.g, DB.frame.backdrop.color.b, DB.frame.backdrop.color.a)
		frame:SetBackdropBorderColor(DB.frame.border.color.r, DB.frame.border.color.g, DB.frame.border.color.b, DB.frame.border.color.a)
	elseif(type == 'StatusBar') then
		frame:SetBackdrop({
			bgFile		= DB.statusbar.backdrop.bgFile,
			edgeFile	= DB.statusbar.backdrop.edgeFile,
			tile		= DB.statusbar.backdrop.tile,
			tileSize	= DB.statusbar.backdrop.tileSize,
			edgeSize	= DB.statusbar.backdrop.edgeSize,
			insets		= DB.statusbar.backdrop.insets
		})
		frame:SetBackdropColor(DB.statusbar.backdrop.color.r, DB.statusbar.backdrop.color.g, DB.statusbar.backdrop.color.b, DB.statusbar.backdrop.color.a)
		frame:SetBackdropBorderColor(DB.statusbar.border.color.r, DB.statusbar.border.color.g, DB.statusbar.border.color.b, DB.statusbar.border.color.a)
		frame:SetStatusBarTexture(DB.statusbar.backdrop.bgFile, 'ARTWORK')
	else
		frame:SetBackdrop({
			bgFile		= DB.frame.backdrop.bgFile,
			edgeFile	= DB.frame.backdrop.edgeFile,
			tile		= DB.frame.backdrop.tile,
			tileSize	= DB.frame.backdrop.tileSize,
			edgeSize	= DB.frame.backdrop.edgeSize,
			insets		= DB.frame.backdrop.insets
		})
		frame:SetBackdropColor(DB.frame.backdrop.color.r, DB.frame.backdrop.color.g, DB.frame.backdrop.color.b, DB.frame.backdrop.color.a)
		frame:SetBackdropBorderColor(DB.frame.border.color.r, DB.frame.border.color.g, DB.frame.border.color.b, DB.frame.border.color.a)
	end
end



function Layout:Initialize()
	DB = Engine.DB.db.profile.layout
	
	-- General layout CVars
	Engine.DB.db.profile.general.userSettings.uiScale = GetCVar('uiScale')
	Engine.DB.db.profile.general.userSettings.useUiScale = GetCVar('useUiScale')
	SetCVar('uiScale', 0.75)
	SetCVar('useUiScale', 1)
	
	return true
end



--[[

]]--