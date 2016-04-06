--[[ stage 3, level 1 loading ]]--

module(..., package.seeall)

function new()

	local l1s3Load = display.newGroup()
	
	local loadTimer
	local loadingImage
	
	local drawScreen = function()
	
		loadingImage = display.newImage("loadingStage3Screen.png")
		
		local goTol1s3 = function()
		
			screenManager:changeScene("l1s3")
			
		end
		
		loadTimer = timer.performWithDelay(1000, goTol1s3, 1)
		
	end
	
	drawScreen()
	
	clean = function()
		
		if loadTimer then timer.cancel(loadTimer); end
		
		if loadingImage then
		
			display.remove(loadingImage)
			loadingImage = nil
		
		end
	end
	
	return l1s3Load
	
end