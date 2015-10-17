local Engine = getglobal('ElronsUI')
local Config = Engine:GetModule('Config')
local Layout = Engine:GetModule('Layout')

function Config:ButtonOKConfigWindow()
	local frame = getglobal('ElronsUI_ConfigFrame')
	
	frame:Hide()
end

function Config:ButtonCancelConfigWindow()
	local frame = getglobal('ElronsUI_ConfigFrame')
	
	frame:Hide()
end



function Config:SetConfigWindowBackdrop(frame)
	local DB = Engine.DB.db.profile.layout
	
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

function Config:CreateConfigWindow()
	local frame, fString
	local areaTitle, areaLeft, areaRight
	local buttonOK, buttonCancel
	local parent = Engine.UIParent
	local name = 'ElronsUI_ConfigFrame'
	
	-- Create frame
	frame = CreateFrame('Frame', name, parent)
	-- Set backdrop and edges
	self:SetConfigWindowBackdrop(frame)
	-- Set width and height
	frame:SetWidth(800)
	frame:SetHeight(600)
	-- Set strata and level
	frame:SetFrameStrata('DIALOG')
	frame:SetFrameLevel(0)
	-- Set center of screen
	frame:SetPoint('CENTER', parent, 'CENTER', 0, 0)
	
	-- Event handling
	frame:EnableMouse(true)
	frame:RegisterForDrag('LeftButton')
	
	-- Hide frame
	frame:Hide()
	
	
	
	-- Create title frame
	areaTitle = CreateFrame('Frame', name..'_TitleFrame', frame)
	-- Set backdrop and edges
	self:SetConfigWindowBackdrop(areaTitle)
	-- Set width and height
	areaTitle:SetWidth(250)
	areaTitle:SetHeight(30)
	-- Set strata and level
	areaTitle:SetFrameStrata('DIALOG')
	areaTitle:SetFrameLevel(99)
	-- Set position
	areaTitle:SetPoint('TOP', frame, 'TOP', 0, 15)
	
	fString = areaTitle:CreateFontString(name..'_TitleString', 'OVERLAY', 'GameFontNormalLarge')
	fString:SetAllPoints()
	fString:SetText(Engine.info.title..' v'..Engine.info.version)
	
	-- Event handling
	areaTitle:EnableMouse(true)
	frame:RegisterForDrag('LeftButton')
	
	
	
	-- Create left area
	areaLeft = CreateFrame('Frame', name..'_AreaLeft', frame)
	-- Set backdrop and edges
	self:SetConfigWindowBackdrop(areaLeft)
	-- Set width and height
	areaLeft:SetWidth(285)
	areaLeft:SetHeight(535)
	-- Set strata and level
	areaLeft:SetFrameStrata('DIALOG')
	areaLeft:SetFrameLevel(1)
	-- Set position
	areaLeft:SetPoint('TOPLEFT', frame, 'TOPLEFT', 8, (-8 - 15))
	
	
	
	-- Create right area
	areaRight = CreateFrame('Frame', name..'_AreaRight', frame)
	-- Set backdrop and edges
	self:SetConfigWindowBackdrop(areaRight)
	-- Set width and height
	areaRight:SetWidth(485)
	areaRight:SetHeight(535)
	-- Set strata and level
	areaRight:SetFrameStrata('DIALOG')
	areaRight:SetFrameLevel(1)
	-- Set position
	areaRight:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', -8, (-8 - 15))
	
	
	
	-- Create Cancel button first
	buttonCancel = CreateFrame('Button', name..'_ButtonCancel', frame)
	-- Set backdrop and edges
	self:SetConfigWindowBackdrop(buttonCancel)
	-- Set width and height
	buttonCancel:SetWidth(100)
	buttonCancel:SetHeight(26)
	-- Set strata and level
	buttonCancel:SetFrameStrata('DIALOG')
	buttonCancel:SetFrameLevel(1)
	-- Set position
	buttonCancel:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -8, 8)
	-- Set font, color and text
	fString = buttonCancel:CreateFontString(name..'_ButtonCancel_String', 'OVERLAY', 'GameFontNormal')
	buttonCancel:SetFontString(fString)
	buttonCancel:SetText('Cancel')
	
	-- Event handling
	buttonCancel:RegisterForClicks('LeftUp')
	buttonCancel:SetScript('OnMouseUp', function(self, button)
		Config:ButtonCancelConfigWindow()
	end)
	
	
	
	-- Create OK button
	buttonOK = CreateFrame('Button', name..'_ButtonOK', frame)
	-- Set backdrop and edges
	self:SetConfigWindowBackdrop(buttonOK)
	-- Set width and height
	buttonOK:SetWidth(100)
	buttonOK:SetHeight(26)
	-- Set strata and level
	buttonOK:SetFrameStrata('DIALOG')
	buttonOK:SetFrameLevel(1)
	-- Set position
	buttonOK:SetPoint('RIGHT', buttonCancel, 'LEFT', -8, 0)
	-- Set font, color and text
	fString = buttonOK:CreateFontString(name..'_ButtonOK_String', 'OVERLAY', 'GameFontNormal')
	buttonOK:SetFontString(fString)
	buttonOK:SetText('OK')
	
	-- Event handling
	buttonOK:RegisterForClicks('LeftUp')
	buttonOK:SetScript('OnMouseUp', function(self, button)
		Config:ButtonOKConfigWindow()
	end)
end