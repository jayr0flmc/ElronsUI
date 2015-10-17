local Engine = getglobal('ElronsUI')

local format	= string.format
local sub		= string.sub
local upper		= string.upper

local atan2		= math.atan2
local modf		= math.modf
local ceil		= math.ceil
local floor		= math.floor
local abs		= math.abs
local sqrt		= math.sqrt
local pi		= math.pi

-- Return short value of a number
function Engine:ShortValue(value)
	if value >= 1e9 then
		return ('%.1fb'):format(value / 1e9):gsub('%.?0+([kmb])$', '%1')
	elseif value >= 1e6 then
		return ('%.1fm'):format(value / 1e6):gsub('%.?0+([kmb])$', '%1')
	elseif value >= 1e3 or value <= -1e3 then
		return ('%.1fk'):format(value / 1e3):gsub('%.?0+([kmb])$', '%1')
	else
		return value
	end
end