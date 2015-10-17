local Engine = getglobal('ElronsUI')
local Chat = Engine:NewModule('Chat')
local Layout = Engine:GetModule('Layout')
local DB

local toggleChat = false
local toggleLog = false



function Chat:CreateLayout()
	local areaChat, areaLog
	local barTop, barBot
	
	areaChat = Layout:CreateWindow('Chat', Engine.UIParent, DB.width, DB.height)
	areaChat:SetPoint('BOTTOMLEFT', Engine.UIParent, 'BOTTOMLEFT', 4, 4)
	areaChat:SetFrameStrata('BACKGROUND')
	areaChat:SetFrameLevel(0)
	barTop = Layout:CreateWindow('Chat_BarTop', areaChat, DB.width - 8, 20)
	barTop:SetPoint('TOP', areaChat, 'TOP', 0, -4)
	barBot = Layout:CreateWindow('Chat_BarBot', areaChat, DB.width - 8, 20)
	barBot:SetPoint('BOTTOM', areaChat, 'BOTTOM', 0, 4)
	
	
	
	areaLog = Layout:CreateWindow('Log', Engine.UIParent, DB.width, DB.height)
	areaLog:SetPoint('BOTTOMRIGHT', Engine.UIParent, 'BOTTOMRIGHT', -4, 4)
	areaLog:SetFrameStrata('BACKGROUND')
	areaLog:SetFrameLevel(0)
	barTop = Layout:CreateWindow('Log_BarTop', areaLog, DB.width - 8, 20)
	barTop:SetPoint('TOP', areaLog, 'TOP', 0, -4)
	barBot = Layout:CreateWindow('Log_BarBot', areaLog, DB.width - 8, 20)
	barBot:SetPoint('BOTTOM', areaLog, 'BOTTOM', 0, 4)
end



function GetToggleStateChat()
	return toggleChat
end
function SetToggleStateChat(toggle)
	toggleChat = toggle
end



function Chat:Initialize()
	DB = Engine.DB.db.profile.chat
	
	self:CreateLayout()
	
	self:General_Init()
	
	return true
end