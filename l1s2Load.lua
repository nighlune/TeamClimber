--[[ stage 2, level 1 loading ]]--

module(..., package.seeall)

function new()

	local l1s2Load = display.newGroup()
	
	local loadTimer
	local loadingImage
	
	local drawScreen = function()
		
		loadingImage = display.newImage("loadingStage2Screen.png")
		
		local goTol1s2 = function()
		
			screenManager:changeScene("l1s2")
			
		end
		
		loadTimer = timer.performWithDelay(1000, goTol1s2, 1)
		
	end
	
	drawScreen()
	
	clean = function()
		
		if loadTimer then timer.cancel(loadTimer); end
		
		if loadingImage then
		
			display.remove(loadingImage)
			loadingImage = nil
			
		end
	end
	
	return l1s2Load
	
end