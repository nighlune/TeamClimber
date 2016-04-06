--[[ level selection ]]--

module(..., package.seeall)

function new()

	--print("inside levelSelection")
	
	local ui = require("ui")
	
	local levelSelectionGroup = display.newGroup()
	--local HUDGroup = display.newGroup()
	
	local drawScreen = function()
	
		--print("inside levelSelection:drawScreen()")
	
		local backgroundImage = display.newImage("levelSelectionScreen.png")
		
		levelSelectionGroup:insert(backgroundImage)
		
		
		
		--LEVEL ONE BUTTON
		local level1Button
		
		local onLevel1Touch = function(event)
					
			if event.phase == "release" and level1Button.isActive then
			
				screenManager:changeScene("l1StageSelection")
				
			end
		end
		
		level1Button = ui.newButton{
			defaultSrc = "level1Button.png",
			defaultX = 100,
			defaultY = 50,
			overSrc = "level1Button.png",
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
		
		--stage1Button:setReferencePoint(display.BottomCenterReferencePoint)
		level1Button.x = (display.contentWidth * .5) - 75
		level1Button.y = (display.contentHeight * .5)
		--stage1Button.isVisible = false
		
		levelSelectionGroup:insert(level1Button)
		--timer.performWithDelay(200, function() stage1Button.isVisible = true; end, 1)
		
		
		
		--BACK BUTTON
		local backButton
		
		local onBackTouch = function(event)
		
			--print("back button pressed")
			
			if event.phase == "release" and backButton.isActive then
			
				screenManager:changeScene("mainMenuLoad")
				
			end
		end
		
		backButton = ui.newButton{
			defaultSrc = "backButton.png",
			defaultX = 100,
			defaultY = 50,
			overSrc = "backButton.png",
			overX = 100,
			overY = 50,
			onEvent = onBackTouch,
			id = "backButton",
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		--backButton:setReferencePoint(display.BottomCenterReferencePoint)
		backButton.x = (display.contentWidth * .5) + 75
		backButton.y = (display.contentHeight * .5)
		--backButton.isVisible = true
		
		levelSelectionGroup:insert(backButton)
		--timer.performWithDelay(200, function() backButton.isVisible = true; end, 1)
	end
	
	drawScreen()
	
	--clean functions
	clean = function()
	
		--print("inside levelSelection:clean()")
		
		--stop physics (if applicable)
		
	end
	
	return levelSelectionGroup
end

	
