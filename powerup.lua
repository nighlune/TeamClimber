--[[ powerup class ]]--

Powerup =
{
	-- member variables
	type = 0,
	
	-- member functions
	getType=
	function()
		return type
	end,
	
	setType=
	function(num)
		if num == 1 then
			type = 1
			-- image1 = display.newImage()
		else
			type = 2
			-- image2 = display.newImage()
		end
	end		
}

function Powerup:new(object)
	object = object or {}
	setmetatable(object, self)
	self.__index = self
	return object
end

