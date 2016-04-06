--[[ main menu load ]]--

module(..., package.seeall)

function new()

	--print("Inside loadmainmenu:new()")
	
	local loadMainMenu = display.newGroup()
	
	local loadTimer
	local loadingImage
	
	local showLoadingScreen = function()
	
		--print("inside loadmainmenu:showLoadingScreen")
	
		--[[
		loadingImage = display.newImageRect("loading.png", 320, 480)
		loadingImage.x = 240; loadingImage.y = 160;
		]]--
		
		loadingImage = display.newImage("loading.png")
		
		local goToLevel = function()
			screenManager:changeScene("mainmenu")
		end
		
		loadTimer = timer.performWithDelay(1000, goToLevel, 1)
	end
	
	--call loading screen for main menu
	showLoadingScreen()
	
	clean = function()
		
		if loadTimer then timer.cancel(loadTimer); end
		
		if loadingImage then		
			display.remove(loadingImage)
			loadingImage = nil
		
		end
	end
	
	return loadMainMenu
end
	