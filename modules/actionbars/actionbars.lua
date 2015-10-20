local Engine = getglobal('ElronsUI')
local ActionBars = Engine:NewModule('ActionBars')
local Layout = Engine:GetModule('Layout')
local DB

function ActionBars:CreateBar(barID, barName)
	local bar
	local name, parent, width, height
	
	name	= 'ActionBar_'..barName
	parent	= Engine.UIParent
	width	= (32 * 12) + (13 * 2)
	height	= 32 + (2 * 2)
	
	bar = Layout:CreateWindow(name, parent, width, height)
	-- Set strata and level
	bar:SetFrameStrata('BACKGROUND')
	bar:SetFrameLevel(0)
	-- Set position
	bar:SetPoint('CENTER', parent, 'CENTER', 0, 0)
	-- Set variables
	bar.id = barID
	
	
	
	return bar
end

function ActionBars:Initialize()
	DB = Engine.DB.db.profile.actionbar
	
	self:CreateBar(1, 'Bar1')
	
	return true
end