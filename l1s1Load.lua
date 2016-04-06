--[[ stage 1, level 1 loading ]]--

module(..., package.seeall)

function new()

	local l1s1Load = display.newGroup()
	
	local loadTimer
	local loadingImage
	
	local drawScreen = function()
	
		loadingImage = display.newImage("loadingStage1Screen.png")
		
		local goTol1s1 = function()
		
			screenManager:changeScene("l1s1")
			
		end
		
		loadTimer = timer.performWithDelay(1000, goTol1s1, 1)
		
	end
	
	drawScreen()
	
	clean = function()
		
		if loadTimer then timer.cancel(loadTimer); end
		
		if loadingImage then
		
			display.remove(loadingImage)
			loadingImage = nil
		
		end
	end
	
	return l1s1Load
	
end