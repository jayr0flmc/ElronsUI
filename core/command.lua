local Engine = getglobal('ElronsUI')
local args = Engine.options.args

--[[
args.range = {
	type	= 'range',
	set		= function() end,
	get		= function() end,
	desc	= 'desc',
	name	= 'name'
}
args.text = {
	type	= 'text',
	set		= function() end,
	get		= function() end,
	desc	= 'desc',
	name	= 'name'
}
args.group = {
	type	= 'group',
	desc	= 'desc',
	name	= 'name',
	args = {
		
	}
}
args.toggle = {
	type	= 'toggle',
	set		= function() end,
	get		= function() end,
	desc	= 'desc',
	name	= 'name'
}
args.color = {
	type	= 'color',
	desc	= 'desc',
	name	= 'name'
}
args.header = {
	type	= 'header',
	desc	= 'desc',
	name	= 'name'
}

function Engine.AddOn:GetWidth()
	return Engine.DB.db.profile.chat.left.width
end
function Engine.AddOn:SetWidth(width)
	Engine.DB.db.profile.chat.left.width = width
end
]]--

function Engine:LoadCommands()
	args.config = {
		type	= 'execute',
		name	= 'config',
		desc	= 'Opens the configuration window.',
		usage	= '/eui config',
		func	= function() getglobal('ElronsUI_ConfigFrame'):Show() end
	}
	
	args.chat = {
		type	= 'group',
		desc	= 'Collection of chat settings',
		name	= 'chat',
		args = {
			toggle = {
				type	= 'toggle',
				set		= SetToggleStateChat,
				get		= GetToggleStateChat,
				desc	= 'Toggle chat',
				name	= 'toggle'
			}
		}
	}
	
	
	
	self.Addon:RegisterChatCommand({'/eui', '/elronsui'}, self.options)
end