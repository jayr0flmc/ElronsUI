SLASH_FRAME1 = '/frame'
SlashCmdList['FRAME'] = function(arg)
	if(arg ~= '') then
		arg = getglobal(arg)
	else
		arg = GetMouseFocus()
	end
	if(arg ~= nil) then FRAME = arg end
	if(arg ~= nil and arg:GetName() ~= nil) then
		local point, relFrame, relPoint, oX, oY = arg:GetPoint()
		
		DEFAULT_CHAT_FRAME:AddMessage('|cffCC0000----------------------------')
		
		DEFAULT_CHAT_FRAME:AddMessage('Name: |cffFFD100'..arg:GetName())
		if(arg:GetParent() and arg:GetParent():GetName()) then
			DEFAULT_CHAT_FRAME:AddMessage('Parent: |cffFFD100'..arg:GetParent():GetName())
		end
		
		DEFAULT_CHAT_FRAME:AddMessage('Width: |cffFFD100'..format('%.2f', arg:GetWidth()))
		DEFAULT_CHAT_FRAME:AddMessage('Heigth: |cffFFD100'..format('%.2f', arg:GetHeight()))
		DEFAULT_CHAT_FRAME:AddMessage('Strata: |cffFFD100'..arg:GetFrameStrata())
		DEFAULT_CHAT_FRAME:AddMessage('Level: |cffFFD100'..arg:GetFrameLevel())
		
		if(oX) then DEFAULT_CHAT_FRAME:AddMessage('X: |cffFFD100'..format('%.2f', oX)) end
		if(oY) then DEFAULT_CHAT_FRAME:AddMessage('Y: |cffFFD100'..format('%.2f', oY)) end
		
		if(relFrame and relFrame:GetName()) then
			DEFAULT_CHAT_FRAME:AddMessage('Point: |cffFFD100'..point..'|r anchored to '..relFrame:GetName()..'\'s |cffFFD100'..relPoint)
		end
		
		DEFAULT_CHAT_FRAME:AddMessage('|cffCC0000----------------------------')
	elseif arg == nil then
		DEFAULT_CHAT_FRAME:AddMessage('Invalid frame name')
	else
		DEFAULT_CHAT_FRAME:AddMessage('Could not find frame info')
	end
end