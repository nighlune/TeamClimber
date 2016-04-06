--[[ stage 2, level 1 ]]--

module(..., package.seeall)

function new()

	--DISPLAY GROUPS
	local l1s3Group = display.newGroup()
	local HUDGroup = display.newGroup()
	
	local levelGroup = display.newGroup()
	
	
	
	--LIBRARIES
	local physics = require("physics")
	local ui = require("ui")
	
	
	
	--BUTTONS (where applicable)
	local pauseButton
	local pauseMenuButton
	
	
	
	--STAGE VARIABLES
	local screenOverlay
	
	local gameIsActive = false
	local canSwipe = true
	
	local waitingForNewRound
	local restartTimer
	
	
	
	--START A NEW ROUND
	local startNewRound = function()
	
		if screenOverlay then
		
			display.remove(screenOverlay)
			screenOverlay = nil
			
		end
		
		canSwipe = true
		waitingForNewRound = false
		gameIsActive = true
		
		pauseButton.isVisible = true
		pauseButton.isActive = true
		
	end
	
	
	
	--GAME OVER
	local gameOver = function(isWin)
	
		local isWin = isWin
		
		gameIsActive = false
		physics.pause()
		
		pauseButton.isVisible = false
		pauseButton.isActive = false
		
		local screenOverlay = display.newRect(0, 0, 960, 640)
		screenOverlay:setFillColor(0, 0, 0, 255)
		screenOverlay.alpha = 0
		
		local gameOverDisplay
		
		--player wins
		if isWin == "yes" then
			
			--gameOverDisplay = diplay.newImageRect( )
		
		else
		
			--gameOverDisplay = display.newImageRect()
			
		end
		
		--menu button
		
		--restart button
		
		--next stage button
		
		--openfeint button
		
		--facebook button
		
		--insert elements into group
		HUDGroup:insert(screenOverlay)
		HUDGroup:insert(gameOverDisplay)
		
		if isWin == "yes" then
		
			--HUDGroup:insert( )
			
		end
		
		--fade in elements
		
		--update best score (if applicable)
		
		--make elements visible
		
	end
	
	
	
	--CALL NEW ROUND
	local callNewRound = function()
	
	end
	
	
	
	--DRAW BACKGROUND
	local drawBackground = function()
	
		local backgroundImage = display.newImage("stage3Screen.png")
		
		l1s3Group:insert(backgroundImage)
		
	end
	
	
	
	--DRAW HEADS UP DISPLAY
	local drawHUD = function()
				
		local onPauseTouch = function(event)
		
			if event.phase == "release" and pauseButton.isActive then
		
				--if the game is running i.e. not paused
				if gameIsActive then
			
					--pause the game and physics
					gameIsActive = false
					physics.pause()
				
					--if there is no overlay for the pause "screen"
					if not screenOverlay then
				
						screenOverlay = display.newRect(0, 0, 640, 960)
						screenOverlay:setFillColor(0, 0, 0, 255)
						HUDGroup:insert(screenOverlay)
					
					end
					
					screenOverlay.alpha = 0.5
				
					--enable/show the menu button
					if pauseMenuButton then
				
						pauseMenuButton.isVisible = true
						pauseMenuButton.isActive = true
						pauseMenuButton:toFront()
					
					end
				
					--enable/show the restart button
					if pauseRestartButton then
				
						pauseRestartButton.isVisible = true
						pauseRestartButton.isActive = true
						pauseRestartButton:toFront()
					
					end
			
					--[[
					--enable/show the stage selection button
					if pauseStageSelectionButton then
				
						pauseStageSelectionButton.isVisible = true
						pauseStageSelectionButton.isActive = true
						pauseStageSelectionButton:toFront()
					
					end
					]]--
				
					pauseButton:toFront()
			
				--if the game is not running i.e. in the pause screen
				else
			
					--if the pause overlay exists, remove it
					if screenOverlay then
				
						display.remove(screenOverlay)
						screenOverlay = nil
					
					end
				
					--hide/disable the menu button if it exists
					if pauseMenuButton then
				
						pauseMenuButton.isVisible = false
						pauseMenuButton.isActive = false
					
					end
				
					--hide/disable the restart button if it exists
					if pauseRestartButton then
				
						pauseRestartButton.isVisible = false
						pauseRestartButton.isActive = false
					
					end
				
					--[[
					--hide/disable the stage selection button if it exists
					if pauseStageSelectionButton then
				
						pauseStageSelectionButton.isVisible = false
						pauseStageSelectionButton.isActive = false
					
					end
					]]--
				
					gameIsActive = true
					physics.start()
				
				end
			end
		end
		
		pauseButton = ui.newButton{
			defaultSrc = "pauseButtonSmall.png",
			defaultX = 50,
			defaultY = 50,
			overSrc = "pauseButtonSmall.png",
			overX = 50,
			overY = 50,
			onEvent = onPauseTouch,
			id = "PauseButton",
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		pauseButton.x = (display.contentWidth * .5) - 130
		pauseButton.y = display.contentHeight * .25 - 75
		
		HUDGroup:insert(pauseButton)
		
		
		
		--MENU BUTTON (ACCESSED FROM PAUSE BUTTON)
		local onPauseMenuTouch = function(event)
		
			if event.phase == "release" and pauseMenuButton.isActive then
				
				--local onComplete = function(event)
				
					--if "clicked" == event.action then
					
						--local i = event.index
						
						--if i == 2 then
						
						--elseif i == 1 then
							
							screenManager:changeScene("mainMenuLoad")
							
						--end
					--end
				--end
				
				--local alert = native.showAlert("Are you sure?", "Your current game will end.", {"Yes", "Cancel"}, onComplete)
				
			end
		end
		
		pauseMenuButton = ui.newButton{
			defaultSrc = "menuButtonSmall.png",
			defaultX = 50,
			defaultY = 50,
			overSrc = "menuButtonSmall.png",
			overX = 50,
			overY = 50,
			onEvent = onPauseMenuTouch,
			id = "PauseMenuButton",
			text = "",
			font = "Arial",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}
		
		pauseMenuButton.x = (display.contentWidth * .5) - 25
		pauseMenuButton.y = display.contentHeight * .25 - 75
		pauseMenuButton.isVisible = false
		pauseMenuButton.isActive = false
		
		HUDGroup:insert(pauseMenuButton)
	
		
		--[[
		--STAGE SELECTION BUTTON (ACCESSED FROM PAUSE BUTTON)
		local onPauseStageSelectionTouch = function(event)
		
			if event.phase == "release" and pauseStageSelectionButton.isActive then
			
				screenManager:changeScene("l1StageSelection")
				
			end
		end
		
		pauseStageSelectionButton = ui.newButton{
			defaultSrc = "stageSelectButtonSmall.png",
			defaultX = 50,
			defaultY = 50,
			overSrc = "stageSelectButtonSmall.png",
			overX = 50,
			overY = 50,
			onEvent = onPauseStageSelectionTouch,
			id = "pauseStageSelectionButton",
			text = "",
			font = "Arial",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}
		
		pauseStageSelectionButton.x = (display.contentWidth * .5) + 10
		pauseStageSelectionButton.y = display.contentHeight * .25 - 75
		pauseStageSelectionButton.isVisible = false
		pauseStageSelectionButton.isActive = false
		
		HUDGroup:insert(pauseStageSelectionButton)
		]]--

		
		--RESTART BUTTON (ACCESSED FROM PAUSE BUTTON)
		onPauseRestartTouch = function(event)
		
			if event.phase == "release" and pauseRestartButton.isActive then
			
				screenManager:changeScene("l1s2Load")
			
			end
		end
		
		pauseRestartButton = ui.newButton{
			defaultSrc = "restartButtonSmall.png",
			defaultX = 50,
			defaultY = 50,
			overSrc = "restartButtonSmall.png",
			overX = 50,
			overY = 50,
			onEvent = onPauseRestartTouch,
			id = "PauseRestartButton",
			text = "",
			font = "Arial",
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}
		
		pauseRestartButton.x = (display.contentWidth * .5) + 80
		pauseRestartButton.y = display.contentHeight * .25 - 75
		pauseRestartButton.isVisible = false
		pauseRestartButton.isActive = false
		
		HUDGroup:insert(pauseRestartButton)		
		
	end
	
	
	
	--ON SCREEN TOUCH FUNCTION
	local onScreenTouch = function(event)
	
		if gameIsActive then
		
		end
	
	end
	
	
	
	--create functions (where applicable)
		
	
	
	--GAME LOOP FUNCTION
	local gameLoop = function()
	
		if gameIsActive then
		
		end
	
	end
	
	
	
	--create level function
	
	
	
	--ON SYSTEM FUNCTION
	local onSystem = function(event)
	
		if event.type == "applicationSuspend" then
		
			if gameIsActive and pauseButton.isVisible then
			
				gameIsActive = false
				physics.pause()
				
				if not screenOverlay then
				
					screenOverlay = display.newRect(0, 0, 640, 960)
					screenOverlay:setFillColor(0, 0, 0, 255)
					HUDGroup:insert(screenOverlay)
				
				end
				
				screenOverlay.alpha = 0.5
				
				if pauseMenuButton then
				
					pauseMenuButton.isVisible = true
					pauseMenuButton.isActive = true
					pauseMenuButton:toFront()
					
				end
				
				pauseButton:toFront()
				
			end
			
		elseif event.type == "applicationExit" then
		
			if system.getInfo("environment") == "device" then
			
				os.exit()
				
			end
		end
	end
	
	
	
	--GAME INITIALIZE FUNCTION
	local gameInit = function()
	
		physics.start(true)
		
		drawBackground()
		drawHUD()
		
		startNewRound()
		
		Runtime:addEventListener("touch", onScreenTouch)
		Runtime:addEventListener("enterFrame", gameLoop)
		Runtime:addEventListener("system", onSystem)
		
	end
	
	
	
	--CLEAN FUNCTION
	clean = function()
	
		physics.stop()
		
		Runtime:removeEventListener("touch", onScreenTouch)
		Runtime:removeEventListener("enterFrame", gameLoop)
		Runtime:removeEventListener("system", onSystem)
		
		for i = HUDGroup.numChildren, 1, -1 do
		
			local child = HUDGroup[i]
			child.parent:remove(child)
			child = nil
		
		end
		
		display.remove(HUDGroup)
		HUDGroup = nil
		
		if levelGroup then
		
			display.remove(levelGroup)
			levelGroup = nil
			
		end

		--stop animations/transitions
		--stop any timers
		--clean the sounds
	end
	
	gameInit()
	
	return l1s3Group
	
end	
	