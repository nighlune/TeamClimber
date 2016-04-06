--[[ main menu ]]--

module(..., package.seeall)

function new()

	--print("inside mainmenu")
	
	local menuGroup = display.newGroup()
	
	--local ui = ui
	local ui = require("ui")
	--local isLevelSelection = false
	
	--load sounds here
	
	local drawScreen = function()
	
		--background image
		--[[
		local backgroundImage = display.newImageRect("mainMenu.png", 320, 480)
		--backgroundImage.x = 240; backgroundImage.y = 160
		backgroundImage.x = 0; backgroundImage.y = 0
		]]--
		
		local backgroundImage = display.newImage("titleScreen.png")
		
		menuGroup:insert(backgroundImage)
		
		--do applicable animations: see mainmenu.lua in Ghosts-vs-Monsters
		
		
		
		--OPENFEINT BUTTON
		local openfeintButton
		
		local onOpenfeintTouch = function(event)
			
			if event.phase == "release" and openfeintButton.isActive then
			
				--print("OpenFeint button Pressed.")
				
				--openfeint.launchDashboard()
				
			end
		end
		
		openfeintButton = ui.newButton{
			defaultSrc = "openfeintButton.png",
			defaultX = 100,
			defaultY = 50,
			overSrc = "openfeintButton.png",
			overX = 100,
			overY = 50,
			onEvent = onOpenfeintTouch,
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		--openFeintButton:setReferencePoint(display.BottomCenterReferencePoint)
		openfeintButton.x = display.contentWidth * .5 + 75
		openfeintButton.y = (display.contentHeight * .5)
		
		menuGroup:insert(openfeintButton)
		
		
		
		--PLAY BUTTON
		local playButton
		
		local onPlayTouch = function(event)
		
			--print("play button pressed")
		
			--if event.phase == "release" and not isLevelSelection and playButton.isActive then\
			if event.phase == "release" and playButton.isActive then
			
				screenManager:changeScene("levelSelection")
			
				--isLevelSelection = true
				--openFeintButton.isActive = false
				--openFeintButton.isActive = false
				
				--[[
				local shadeRect = display.newRect(0, 0, 320, 480)
				shadeRect:setFillColor(0, 0, 0, 255)
				shadeRect.alpha = 0
				menuGroup:insert(shadeRect)
				transition.to(shadeRect, {time = 100, alpha = 0.85})
				]]--
				
				--[[
				local levelSelectionBackground = display.newImageRect(" ")
				levelSelectionBackground.x = 240
				levelSelectionBackground.y = 160
				levelSelectionBackground.isVisible = false
				menuGroup:insert(levelSelectionBackground)
				timer.performWithDelay(200, function() levelSelectionBackground.isVisible = true; end, 1)
				]]--
				
				--[[
				--level 1 button
				local level1Button
				
				local onLevel1Touch = function(event)
				
					print("level 1 button pressed")
					
					if event.phase == "release" and level1Button.isActive then
					
						--audio.stop(backgroundSound)
						--audio.dispose(backgroundSound); backgroundSound = nil
						
						level1Button.isActive = false
						screenManager:changeScene("loadlevel1")
						
					end
				end
				
				level1Button = ui.newButton{
					defaultSrc = "stage1Button.png",
					defaultX = 100,
					defaultY = 50,
					overSrc = "stage1Button.png",
					overX = 100,
					overY = 50,
					onEvent = onLevel1Touch,
					id = "level1Button",
					text = "", 
					font = "Arial",
					textColor = {255, 255, 255, 255},
					size = 16,
					emboss = false
				}
				
				level1Button.x = 300
				level1Button.y = 200
				level1Button.isVisible = false
				
				menuGroup:insert(level1Button)
				timer.performWithDelay(200, function() level1Button.isVisible = true; end, 1)
				]]--
				
				--[[
				local stageSelectButton
				
				local onStageSelectionTouch = function(event)
				
					print("stage selection button pressed")
					
					if event.phase == "release" and stageSelectionButton.isActive then
					
						stageSelectionButton.isActive = false
						screenManager:changeScene("levelSelecton")
						
					end
				end
				
				stageSelectionButton = ui.newButton{
					defaultSrc = "levelSelection.png",
					defaultX = 100,
					defaultY = 50,
					overSrc = "levelSelection.png",
					overX = 100,
					overY = 50,
					onEvent = onLevel1Touch,
					id = "levelSelectionButton",
					text = "", 
					font = "Arial",
					textColor = {255, 255, 255, 255},
					size = 16,
					emboss = false
				}
				
				stageSelectionButton.x = 200
				stageSelectionButton.y = 200
				stageSelectionButton.isVisible = false
				
				menuGroup:insert(stageSelectionButton)
				timer.performWithDelay(200, function() stageSelectionButton.isVisible = true; end, 1)
				
				--add additional level buttons here
				
				--close button
				local closeButton
				
				local onCloseTouch = function(event)
				
					print("close button pressed")
					
					if event.phase == "release" then
					
						--audio.play([insert sound here])
						
						display.remove(levelSelectionBackground); levelSelectionBackground = nil
						--display.remove(level1Button); level1Button = nil
						--remove other buttons here
						display.remove(stageSelectionButton); stageSelectionButton = nil
						display.remove(closeButton); closeButton = nil
						display.remove(shadeRect); shadeRect = nil
						
						isLevelSelection = false
						playButton.isActive = true
						openFeintButton.isActive = true
						
					end
				end
				
				closeButton = ui.newButton{
					defaultSrc = "exitButton.png",
					defaultX = 100,
					defaultY = 50,
					overSrc = "exitButton.png",
					overX = 100,
					overY = 50,
					onEvent = onCloseTouch,
					id = "closeButton",
					text = "",
					font = "Arial",
					textColor = {255, 255, 255, 255},
					size = 16,
					emboss = false
				}
				
				closeButton.x = 100
				closeButton.y = 200
				closeButton.isVisible = false
				
				menuGroup:insert(closeButton)
				timer.performWithDelay(200, function() closeButton.isVisible = true; end, 1)
				]]--
				
			end
		end
		
		playButton = ui.newButton{
			defaultSrc = "playButton.png",
			defaultX = 100,
			defaultY = 50,
			overSrc = "playButton.png",
			overX = 100,
			overY = 50,
			onEvent = onPlayTouch,
			id = "playButton",
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		--playButton:setReferencePoint(display.BottomCenterReferencePoint)
		--playButton.x = 365
		--playButton.y = 440
		playButton.x = display.contentWidth * .5 - 75
		playButton.y = (display.contentHeight * .5)
		
		menuGroup:insert(playButton)
		
		
		
		--EXIT BUTTON
		local exitButton
		
		local onExitTouch = function(event)
			
			if event.phase == "release" and exitButton.isActive then
			
				--print("OpenFeint button Pressed.")
				
				--openfeint.launchDashboard()
				
			end
		end
		
		exitButton = ui.newButton{
			defaultSrc = "exitButton.png",
			defaultX = 100,
			defaultY = 50,
			overSrc = "exitButton.png",
			overX = 100,
			overY = 50,
			onEvent = onExitTouch,
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		--openFeintButton:setReferencePoint(display.BottomCenterReferencePoint)
		exitButton.x = display.contentWidth * .5 - 75
		exitButton.y = (display.contentHeight * .5) + 75
		
		menuGroup:insert(exitButton)
		
		--animate buttons here: see mainmenu.lua in Ghosts-vs.-Monsters
	
	end
	
	drawScreen()
	
	local cleanSounds = function()
	
		audio.stop()
		
		if tapSound then
		
			audio.dispose(tapSound)
			tapSound = nil
		
		end
	end
	
	clean = function()
	
		--check button animations
		
		cleanSounds()
	
	end
	
	return menuGroup
end	