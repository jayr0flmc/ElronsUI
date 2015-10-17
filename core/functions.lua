local Engine = getglobal('ElronsUI')

Engine.WaitFrames = {}

function Engine:Kill(object)
	if(object.UnregisterAllEvents) then
		object:UnregisterAllEvents()
		object:SetParent(self.HiddenFrame)
	else
		object.Show = object.Hide
	end
	
	object:Hide()
end

function Engine:Wait(delay, func)
	local frame, count
	
	count = table.getn(self.WaitFrames)
	self:Debug('count: '..tostring(count), 'debug')
	frame = CreateFrame('Frame', 'ElronsUI_WaitFrame'..(count + 1), self.UIParent)
	frame.left = delay
	frame.func = func
	frame:SetScript('OnUpdate', function(self, elapsedSec)
		if(self.left > 0) then self.left = self.left - elapsedSec end
		
		if(self.left <= 0) then
			pcall(self.func)
			
			self = nil
		end
	end)
	
	return true
end