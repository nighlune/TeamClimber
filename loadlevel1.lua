--[[ level 1 load ]]--

module(..., package.seeall)

function new()

	--print("inside loadlevel1:new()")

	local loadLevel1 = display.newGroup()
	
	local loadTimer
	local loadingImage
	
	local showLoadingScreen = function()
	
		--print("inside loadlevel1:showLoadingScreen")
		
		--loadingImage = display.newImageRect("stage1.png", 320, 480)
		--loadingImage.x = 240; loadingImage.y = 160
		
		loadingImage = display.newImage("stage1.png")
		
		local goToLevel = function()
		
			screenManager:changeScene("level1")
			
		end
		
		loadTimer = timer.performWithDelay(1000, goToLevel, 1)
		
	end
	
	showLoadingScreen()
	
	clean = function()
	
		--print("inside loadlevel1:clean()")
	
		if loadTimer then timer.cancel(loadTimer); end
		
		if loadingImage then
		
			display.remove(loadingImage)
			loadingImage = nil
			
		end
	end
	
	return loadLevel1
	
end