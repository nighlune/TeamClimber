--[[ climber class ]]--

Climber =
{
	-- member variables
	health = 10,
	life = 5,
	
	powerup = false,
	hook = false,
	
	
	xCoord = 0,
	yCoord = 0,
	
	--image = display.newImage("explorer_rt.png", 220, 427),
	--myName = "Climber",
	-- member functions
	
	-- getHealth / setHealth
	getHealth = 
	function()
		return health
	end,
	
	setHealth = 
	function(h)
		health = health + h
	end,
	
	-- getLife / setLife
	getLife =
	function()
		return life
	end,
	
	setLife =
	function(l)
		life = life + l
	end,
	
	-- getPowerup / setPowerup
	getPowerup =
	function()
		return powerup
	end,
	
	setHook =
	function(flag)
		hook = flag
		print("yay")
	end,
	
	setPowerup =
	function(flag)
		powerup = flag
	end,
	
	-- getX / setX
	getX =
	function()	
		return xCoord
	end,
	
	setX = 
	function(x)
		xCoord = x
	end,
	
	-- setY / getY
	getY = 
	function()
		return yCoord
	end,
	
	setY = 
	function(y)
		yCoord = y
	end
}

function Climber:new(object)
	object = object or {}
	setmetatable(object, self)
	self.__index = self
	return object
end
	

