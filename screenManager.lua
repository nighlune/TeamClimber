--[[ screenManager ]]--

module(..., package.seeall)

screenManagerView = display.newGroup()
currView = display.newGroup()
nextView = display.newGroup()
effectView = display.newGroup()
--
local currScreen, nextScreen
local currScene = "main"
local nextScene = "main"
local newScene
local fxTime = 200
local safeDelay = 50
local isChangingScene = false
--
screenManagerView:insert(currView)
screenManagerView:insert(nextView)
screenManagerView:insert(effectView)
--
currView.x = 0
currView.y = 0
nextView.x = display.contentWidth
nextView.y = 0

--[[
--GET COLOR
local function getColor ( arg1, arg2, arg3 )
	--
	local r, g, b
	--
	if type(arg1) == "nil" then
		arg1 = "black"
	end
	--
	if string.lower(arg1) == "red" then
		r=255
		g=0
		b=0
	elseif string.lower(arg1) == "green" then
		r=0
		g=255
		b=0
	elseif string.lower(arg1) == "blue" then
		r=0
		g=0
		b=255
	elseif string.lower(arg1) == "yellow" then
		r=255
		g=255
		b=0
	elseif string.lower(arg1) == "pink" then
		r=255
		g=0
		b=255
	elseif string.lower(arg1) == "white" then
		r=255
		g=255
		b=255
	elseif type (arg1) == "number"
	   and type (arg2) == "number"
	   and type (arg3) == "number" then
		r=arg1
		g=arg2
		b=arg3
	else
		r=0
		g=0
		b=0
	end
	--
	return r, g, b
	--
end
]]--



--CHANGE CONTROLS

--fxTime
function screenManager:changeFxTime(newFxTime)
  if type(newFxTime) == "number" then
    fxTime = newFxTime
  end
end

-- safeDelay
function screenManager:changeSafeDelay (newSafeDelay)
  if type(newSafeDelay) == "number" then
    safeDelay = newSafeDelay
  end
end



--GET SCENES
function screenManager:getCurrScene()
	return currScene
end
--
function screenManager:getNextScene()
	return nextScene
end



--CLEAN GROUPS
local function cleanGroups(curGroup, level)
	
	if curGroup.numChildren then
		while curGroup.numChildren > 0 do
			cleanGroups(curGroup[curGroup.numChildren], level + 1)
		end
		
		if level > 0 then
			display.remove( curGroup )
			--curGroup:removeSelf()
		end
		
	else
		--curGroup:removeSelf()
		display.remove(curGroup)
		curGroup = nil
		return true
	end
end



--CALL CLEAN FUNCTION
local function callClean(moduleName)

	--print("inside screenManager:callClean()")
	
	if type(package.loaded[moduleName]) == "table" then
		if string.lower(moduleName) ~= "main" then
			for k,v in pairs(package.loaded[moduleName]) do
				if k == "clean" and type(v) == "function" then
					package.loaded[moduleName].clean()
				end
			end
		end
	end
end



--UNLOAD SCENE
local function unloadScene ( moduleName )

	--print("inside screenManager:unloadScene()")
	
	if moduleName ~= "main" and type(package.loaded[moduleName]) == "table" then
		package.loaded[moduleName] = nil
		local function garbage(event)
			collectgarbage("collect")
		end
		
		garbage()
		timer.performWithDelay(fxTime,garbage)
	end
end


 
--LOAD SCENE 
local function loadScene ( moduleName, target )

	--print("inside screenManager:loadScene")
	
	--test parameters
	if type(moduleName) == "nil" then
	
		--print("arg1 is nil")
		
		return true
	end
	
	if type(target) == "nil" then
	
		--print("arg2 is nil")
		
		target = "next"
	end
	
	--load choosed scene
	
	--prev
 	if string.lower(target) == "curr" then
	
		--print("previous scene")

 		callClean(moduleName)
 		cleanGroups(currView, 0)
		
 		if nextScene == moduleName then
 			cleanGroups(nextView, 0)
 		end
		
 		unloadScene(moduleName)

		currScreen = require(moduleName).new()
		currView:insert(currScreen)
		currScene = moduleName

	--next
	else
	
		--print("next scene")

		callClean (moduleName)
		cleanGroups(nextView,0)

 		if currScene == moduleName then
 			cleanGroups(currView,0)
 		end

 		unloadScene(moduleName)

		nextScreen = require(moduleName).new()
		nextView:insert(nextScreen)
		nextScene = moduleName	
	end	
end



--LOAD CURRENT SCENE
function screenManager:loadCurrScene (moduleName)

	--print("inside screenManager:loadCurrScene")
	
	loadScene(moduleName, "curr")
end



--LOAD NEXT SCENE
function screenManager:loadNextScene (moduleName)

	--print("inside screenManager:loadNextScene")
	
	loadScene(moduleName, "next")
end



--EFFECT ENDED 
local function fxEnded(event)

	--print("inside screenManager:fxEnded")
 	    
	currView.x = 0
	currView.y = 0
	currView.xScale = 1
	currView.yScale = 1

	callClean  ( currScene )
	cleanGroups( currView ,0)
	unloadScene( currScene )

	currScreen = nextScreen
	currScene = newScene
	currView:insert(currScreen)

	nextView.x = display.contentWidth
	nextView.y = 0
	nextView.xScale = 1
	nextView.yScale = 1

	isChangingScene = false 
end



--CHANGE SCENE
function screenManager:changeScene(nextLoadScene, effect, arg1, arg2, arg3)

	--print("inside screenManager:changeScene")
	
	--if is changing scene, return without do anything
 	if isChangingScene then
	
		--print("returning true")
		
 		return true
		
 	else
	
		--print("isChangingScene = true")
		
 		isChangingScene = true
 	end
 
	--if is the same, don't change        
	if currScene then
		if string.lower(currScene) == string.lower(nextLoadScene) then
		
			--print("don't change")
			
			return true
		end
	end
        
	newScene = nextLoadScene
	local showFx
 
	--TRANSITION EFFECTS
	
	--EFFECT: move from right        
	if effect == "moveFromRight" then
                        
		nextView.x = display.contentWidth
		nextView.y = 0
		
		loadScene(newScene)
		
		showFx = transition.to(nextView, {x = 0, time = fxTime})
		showFx = transition.to(currView, {x = display.contentWidth * -1, time = fxTime})
		--
		timer.performWithDelay(fxTime + safeDelay, fxEnded)
		
	--EFFECT: over from right        
	elseif effect == "overFromRight" then
        
		nextView.x = display.contentWidth
		nextView.y = 0
		
		loadScene(newScene)
		
		showFx = transition.to(nextView, {x = 0, time = fxTime})
		
		timer.performWithDelay(fxTime + safeDelay, fxEnded)
		
	--EFFECT: move from left        
	elseif effect == "moveFromLeft" then
        
		nextView.x = display.contentWidth * -1
		nextView.y = 0
		
		loadScene(newScene)
		
		showFx = transition.to(nextView, {x = 0, time = fxTime})
		showFx = transition.to (currView, {x = display.contentWidth, time = fxTime})
		
		timer.performWithDelay(fxTime + safeDelay, fxEnded)
        
	--EFFECT: over from left        
	elseif effect == "overFromLeft" then
        
		nextView.x = display.contentWidth * -1
		nextView.y = 0
		
		loadScene(newScene)
		
		showFx = transition.to(nextView, {x = 0, time = fxTime})
		
		timer.performWithDelay(fxTime + safeDelay, fxEnded)
		
	--EFFECT: move from top
	elseif effect == "moveFromTop" then

		nextView.x = 0
		nextView.y = display.contentHeight * -1
		
		loadScene(newScene)
		
		showFx = transition.to(nextView, {y = 0, time = fxTime})
		showFx = transition.to(currView, {y = display.contentHeight, time = fxTime})
		
		timer.performWithDelay(fxTime + safeDelay, fxEnded)
        
	--EFFECT: over from top        
	elseif effect == "overFromTop" then
        
		nextView.x = 0
		nextView.y = display.contentHeight * -1
		
		loadScene(newScene)
		
		showFx = transition.to(nextView, {y = 0, time = fxTime })
		
		timer.performWithDelay(fxTime + safeDelay, fxEnded)
		
	--EFFECT: move from bottom
	elseif effect == "moveFromBottom" then

		nextView.x = 0
		nextView.y = display.contentHeight
		
		loadScene(newScene)
		
		showFx = transition.to(nextView, {y = 0, time = fxTime})
		showFx = transition.to(currView, {y = display.contentHeight * -1, time = fxTime})
		
		timer.performWithDelay(fxTime + safeDelay, fxEnded)
        
	--EFFECT: over from bottom
	elseif effect == "overFromBottom" then
        
		nextView.x = 0
		nextView.y = display.contentHeight
		
		loadScene(newScene)
		
		showFx = transition.to(nextView, {y = 0, time = fxTime})
		
		timer.performWithDelay(fxTime + safeDelay, fxEnded)
		
	--EFFECT: crossfade
	elseif effect == "crossfade" then

		nextView.x = display.contentWidth
		nextView.y = 0
		
		loadScene(newScene)
		
		nextView.alpha = 0
		nextView.x = 0
		
		showFx = transition.to(nextView, {alpha = 1, time = fxTime * 2})
		
		timer.performWithDelay(fxTime * 2 + safeDelay, fxEnded)
		
	--EFFECT: fade
	-- ARG1 = color [string]
	-----------------------------------
	-- ARG1 = red   [number]
	-- ARG2 = green [number]
	-- ARG3 = blue  [number]
	-----------------------------------
	--uncomment getColor() in order to use
	elseif effect == "fade" then
        
		local r, g, b = getColor(arg1, arg2, arg3)
		
		nextView.x = display.contentWidth
		nextView.y = 0
		
		loadScene (newScene)
		
		local fade = display.newRect(0 - display.contentWidth, 0 - display.contentHeight, display.contentWidth * 3, display.contentHeight * 3)
		fade.alpha = 0
		fade:setFillColor(r,g,b)
		effectView:insert(fade)
		
		showFx = transition.to(fade, {alpha = 1.0, time = fxTime})

		timer.performWithDelay(fxTime + safeDelay, fxEnded)

		local function returnFade(event)
                
			showFx = transition.to(fade, {alpha = 0, time = fxTime})

			local function removeFade(event)
				fade:removeSelf()
			end

			timer.performWithDelay(fxTime + safeDelay, removeFade)

		end

		timer.performWithDelay(fxTime + safeDelay + 1, returnFade)

	--EFFECT: flip        
	elseif effect == "flip" then
        
		showFx = transition.to(currView, {xScale = 0.001, time = fxTime})
		showFx = transition.to(currView, {x = display.contentWidth * 0.5, time = fxTime})

		loadScene(newScene)

		nextView.xScale = 0.001
		nextView.x = display.contentWidth * 0.5

		showFx = transition.to(nextView, {xScale = 1, delay = fxTime, time = fxTime})
		showFx = transition.to(nextView, {x = 0, delay = fxTime, time = fxTime})
		
		timer.performWithDelay(fxTime * 2 + safeDelay, fxEnded)
		
	--EFFECT: down flip        
	elseif effect == "downFlip" then
        
		showFx = transition.to(currView, {xScale = 0.7, time = fxTime})
		showFx = transition.to(currView, {yScale = 0.7, time = fxTime})
		showFx = transition.to(currView, {x = display.contentWidth * 0.15, time = fxTime})
		showFx = transition.to(currView, {y = display.contentHeight * 0.15, time = fxTime})
		showFx = transition.to(currView, {xScale = 0.001, delay = fxTime, time = fxTime})
		showFx = transition.to(currView, {x = display.contentWidth * 0.5, delay = fxTime, time = fxTime})
		
		loadScene(newScene)
		
		nextView.x = display.contentWidth * 0.5
		nextView.xScale = 0.001
		nextView.yScale = 0.7
		nextView.y = display.contentHeight * 0.15
		
		showFx = transition.to(nextView, {x = display.contentWidth * 0.15, delay = fxTime * 2, time = fxTime})
		showFx = transition.to(nextView, {xScale = 0.7, delay = fxTime * 2, time = fxTime})
		showFx = transition.to(nextView, {xScale = 1, delay = fxTime * 3, time = fxTime})
		showFx = transition.to(nextView, {yScale = 1, delay = fxTime * 3, time = fxTime})
		showFx = transition.to(nextView, {x = 0, delay = fxTime * 3, time = fxTime})
		showFx = transition.to(nextView, {y = 0, delay = fxTime * 3, time = fxTime})
		
		timer.performWithDelay(fxTime * 4 + safeDelay, fxEnded)
		
	--EFFECT: none        
	else
	
		--print("no effects")
		
		timer.performWithDelay(0, fxEnded)
		loadScene(newScene)
	end
    
	return true
	
end
	
		