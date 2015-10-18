local Engine = getglobal('ElronsUI')
local Layout = Engine:NewModule('Layout')
local DB

function Layout:CreateFrame(type, name, parent, width, height, backdrop)
	local frame
	local backdrop = backdrop or false
	name = 'ElronsUI_'..name
	
	-- Create frame
	frame = CreateFrame(type, name, parent)
	-- Set width and height
	frame:SetWidth(width)
	frame:SetHeight(height)
	-- Set center of screen
	frame:SetPoint('CENTER', parent, 'CENTER', 0, 0)
	-- Set backdrop and edges
	if(backdrop == true) then
		self:SetBackdrop(frame, type)
	end
	
	return frame
end

function Layout:SetBackdrop(frame, type)
	local type = type or ''
	
	if(type == 'StatusBar') then
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
			bgFile		= DB.window.backdrop.bgFile,
			edgeFile	= DB.window.backdrop.edgeFile,
			tile		= DB.window.backdrop.tile,
			tileSize	= DB.window.backdrop.tileSize,
			edgeSize	= DB.window.backdrop.edgeSize,
			insets		= DB.window.backdrop.insets
		})
		frame:SetBackdropColor(DB.window.backdrop.color.r, DB.window.backdrop.color.g, DB.window.backdrop.color.b, DB.window.backdrop.color.a)
		frame:SetBackdropBorderColor(DB.window.border.color.r, DB.window.border.color.g, DB.window.border.color.b, DB.window.border.color.a)
	end
end



function Layout:CreateWindow(name, parent, width, height)
	local frame
	name = 'ElronsUI_'..name
	
	-- Create frame
	frame = CreateFrame('Frame', name, parent)
	-- Set width and height
	frame:SetWidth(width)
	frame:SetHeight(height)
	-- Set center of screen
	frame:SetPoint('CENTER', parent, 'CENTER', 0, 0)
	-- Set backdrop and edges
	self:SetBackdrop(frame)
	
	return frame
end

function Layout:CreateButton(name, width, height, parent, anchor)
	local button
	name = 'ElronsUI_'..name
	
	-- Create button
	button = CreateFrame('Button', name, parent)
	-- Set width and height
	button:SetWidth(width)
	button:SetHeight(height)
	-- Set position
	button:SetPoint(anchor.point, anchor.relFrame, anchor.relPoint, anchor.oX, anchor.oY)
	-- Set backdrop and edges
	self:SetBackdrop(frame)
	
	return button
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