--[[ main menu loading ]]--

module(..., package.seeall)

function new()

	--print("Inside loadmainmenu:new()")
	
	local mainMenuLoad = display.newGroup()
	
	local loadTimer
	local loadingImage
	
	local drawScreen = function()
	
		--print("inside loadmainmenu:showLoadingScreen")
	
		--[[
		loadingImage = display.newImageRect("loading.png", 320, 480)
		loadingImage.x = 240; loadingImage.y = 160;
		]]--
		
		loadingImage = display.newImage("loadingScreen.png")
		
		local goToMainMenu = function()
		
			screenManager:changeScene("mainMenu")
			
		end
		
		loadTimer = timer.performWithDelay(1000, goToMainMenu, 1)
		
	end
	
	--call loading screen for main menu
	drawScreen()
	
	clean = function()
		
		if loadTimer then timer.cancel(loadTimer); end
		
		if loadingImage then
		
			display.remove(loadingImage)
			loadingImage = nil
		
		end
	end
	
	return mainMenuLoad
end