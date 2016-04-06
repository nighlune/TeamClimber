--[[ main ]]--

display.setStatusBar(display.HiddenStatusBar)

local oldTimerCancel = timer.cancel

timer.cancel = function(t)

	if t then
		oldTimerCancel(t)
	
	end
end

local oldRemove = display.remove

display.remove = function(o)

	if o ~= nil then		
		Runtime:removeEventListener("enterFrame", o)
		oldRemove(o)
		o = nil
		
	end
end

--import screenManager class
local screenManager = require("screenManager")

--create a main group
local mainGroup = display.newGroup()

--main function
local function main()

	--print("inside main")

	mainGroup:insert(screenManager.screenManagerView)
	
	--[[
	openfeint = require("openfeint")
	openfeint.init("App Key Here", "App Secret Here", "TeamClimber", "App ID Here")
	]]--
	
	screenManager:changeScene("mainMenuLoad")
	
	--print("Inside main")
	
	return true
end

--start teamClimber
main()
	