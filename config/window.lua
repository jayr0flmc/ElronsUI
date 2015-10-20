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



function Config:CreateConfigWindow()
	local frame, fString
	local areaTitle, areaLeft, areaRight
	local buttonOK, buttonCancel
	local parent = Engine.UIParent
	local name = 'ConfigFrame'
	
	-- Create frame
	frame = Layout:CreateWindow(name, parent, 800, 600, 'DIALOG', 0)
	
	-- Event handling
	frame:EnableMouse(true)
	frame:RegisterForDrag('LeftButton')
	-- Adjust variables
	frame.protected = true
	
	-- Hide frame
	frame:Hide()
	
	
	
	-- Creat title frame
	areaTitle = Layout:CreateFrame('Frame', name..'_TitleFrame', frame, 250, 30, true, 'DIALOG', 99)
	-- Set position
	areaTitle:SetPoint('TOP', frame, 'TOP', 0, 15)
	
	-- Font string
	fString = areaTitle:CreateFontString(nil, 'OVERLAY', 'GameFontNormalLarge')
	fString:SetAllPoints()
	fString:SetText(Engine.info.title..' v'..Engine.info.version)
	-- Save as variable
	areaTitle.text = fString
	
	-- Event handling
	areaTitle:EnableMouse(true)
	areaTitle:RegisterForDrag('LeftButton')
	
	
	
	-- Create left area
	areaLeft = Layout:CreateFrame('Frame', name..'_AreaLeft', frame, 285, 535, true, 'DIALOG', 1)
	-- Set position
	areaLeft:SetPoint('TOPLEFT', frame, 'TOPLEFT', 8, (-8 - 15))
	
	-- Create right area
	areaRight = Layout:CreateFrame('Frame', name..'_AreaRight', frame, 485, 535, true, 'DIALOG', 1)
	-- Set position
	areaRight:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', -8, (-8 - 15))
	
	
	
	-- Create cancel button first
	buttonCancel = Layout:CreateButton(name..'_ButtonCancel', frame, 100, 26, 'DIALOG', 1)
	-- Set position
	buttonCancel:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -8, 8)
	-- Set font, color and text
	fString = buttonCancel:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	buttonCancel:SetFontString(fString)
	buttonCancel:SetText('Cancel')
	
	-- Event handling
	buttonCancel:RegisterForClicks('LeftUp')
	buttonCancel:SetScript('OnMouseUp', function()
		self:ButtonCancelConfigWindow()
	end)
	
	
	
	-- Create OK button first
	buttonOK = Layout:CreateButton(name..'_ButtonOK', frame, 100, 26, 'DIALOG', 1)
	-- Set position
	buttonOK:SetPoint('RIGHT', buttonCancel, 'LEFT', -8, 0)
	-- Set font, color and text
	fString = buttonOK:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	buttonOK:SetFontString(fString)
	buttonOK:SetText('OK')
	
	-- Event handling
	buttonOK:RegisterForClicks('LeftUp')
	buttonOK:SetScript('OnMouseUp', function()
		self:ButtonOKConfigWindow()
	end)
end



function Config:InitConfigWindow()
	self:CreateConfigWindow()
	
	return true
end