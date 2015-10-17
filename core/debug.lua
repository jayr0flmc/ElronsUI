local Engine = getglobal('ElronsUI')

DEBUG_INFO	= true
DEBUG_DEBUG	= false
DEBUG_WARN	= true
DEBUG_ERROR	= true
DEBUG_CRIT	= true

-- Own chat messages
function Engine:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage('|cff278009ElronsUI|r: '..msg)
end

function Engine:Debug(msg, type, suffix)
	local prefix	= '|cff278009ElronsUI|r:'
	local message	= ''
	local suffix	= suffix or ''
	local output	= false
	
	if(string.upper(type) == 'INFO' and DEBUG_INFO) then
		prefix = prefix..' [|cff329632INFO|r]'
		
		output = true
	end
	if(string.upper(type) == 'DEBUG' and DEBUG_DEBUG) then
		prefix = prefix..' [|cff2121C4DEBUG|r]'
		
		output = true
	end
	if(string.upper(type) == 'WARN' and DEBUG_WARN) then
		prefix = prefix..' [|cffC4C421WARNING|r]'
		
		output = true
	end
	if(string.upper(type) == 'ERROR' and DEBUG_ERROR) then
		prefix = prefix..' [|cffFF0000ERROR|r]'
		
		output = true
	end
	if(string.upper(type) == 'CRIT' and DEBUG_CRIT) then
		prefix = prefix..' [|cff963232CRITICAL|r]'
		
		output = true
	end
	
	if(output == true) then
		message = prefix..' '..msg
		if(strlen(suffix) > 0) then message = message..' ['..suffix..']' end
		
		DEFAULT_CHAT_FRAME:AddMessage(message)
	end
end