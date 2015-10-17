local Engine = getglobal('ElronsUI')

-- Create structure
Engine.Modules = {
	loaded		= {},
	activated	= {},
	deactivated	= {},
	
	count = {
		loaded		= 0,
		activated	= 0,
		deactivated	= 0
	}
}



function Engine:NewModule(name, system)
	local object = {}
	local system = system or false
	
	-- Pre-define general variables
	object.info = {
		name	= name,
		author	= '',
		version	= ''
	}
	object.deps			= {}
	object.loaded		= false
	object.initialized	= false
	object.system		= system
	
	
	object.Initialize = function()
		Engine:Debug(format('Module [%s] has no script file!', tostring(self.info.name)), 'warn')
		
		self.initialized = true
		
		return true
	end
	
	
	
	-- Save as variable
	self.Modules.loaded[name] = object
	table.insert(self.Modules.activated, name)
	
	self:Debug(format('Module [%s] successfully loaded.', tostring(name)), 'info')
	return object
end

function Engine:IsModule(name)
	if(not self.Modules.loaded[name]) then
		--self:Debug(format('Module [%s] is not loaded!', tostring(name)), 'debug')
		
		return false
	end
	
	return true
end
function Engine:GetModule(name)
	return self.Modules.loaded[name]
end

function Engine:InitModule(name)
	self:Debug(format('Try to initialize module [%s]...', tostring(name)), 'debug')
	if(self:IsModule(name)) then
		local module = self:GetModule(name)
		
		if(module ~= nil and module.Initialize) then
			self:Debug(format('Initializing module [%s]...', tostring(name)), 'debug')
			local _, catch = pcall(module.Initialize, module)
			
			if(catch) then
				self:Debug(format('Module [%s] successfully initialized.', tostring(name)), 'info')
			else
				self:Debug(format('Can\'t initialize module [%s]!', tostring(name)), 'error')
				
				return false
			end
		else
			self:Debug(format('Can\'t initialize module [%s]!', tostring(name)), 'error')
			
			return false
		end
	else
		self:Debug(format('Module [%s] is not loaded!', tostring(name)), 'warn')
		
		return false
	end
	
	return true
end
function Engine:InitModules(modules)
	local error = false
	
	for _, module in pairs(modules) do
		if(self:InitModule(module) == false) then error = true end
	end
	
	return error
end