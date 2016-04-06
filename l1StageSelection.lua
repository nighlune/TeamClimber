--[[ stage selection screen, level 1 ]]--

module(..., package.seeall)

function new()

	local ui = require("ui")
	
	local l1StageSelectionGroup = display.newGroup()
	
	local drawScreen = function()
	
		local backgroundImage = display.newImage("stageSelectionScreen.png")
		
		l1StageSelectionGroup:insert(backgroundImage)
		
		
		
		--STAGE ONE BUTTON
		local stage1Button
		
		local onStage1Touch = function(event)
		
			if event.phase == "release" and stage1Button.isActive then
			
				screenManager:changeScene("l1s1Load")
				
			end
		end
		
		stage1Button = ui.newButton{
			defaultSrc = "stage1Button.png",
			defaultX = 100,
			defaultY = 50,
			overSrc = "stage1Button.png",
			overX = 100,
			overY = 50,
			onEvent = onStage1Touch,
			id = "stage1Button",
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		stage1Button.x = (display.contentWidth * .5) - 75
		stage1Button.y = (display.contentHeight * .5)
		
		l1StageSelectionGroup:insert(stage1Button)
		
		
		
		--STAGE TWO BUTTON
		local stage2Button
		
		local onStage2Touch = function(event)
		
			if event.phase == "release" and stage2Button.isActive then
			
				screenManager:changeScene("l1s2Load")
				
			end
		end
		
		stage2Button = ui.newButton{
			defaultSrc = "stage2Button.png",
			defaultX = 100,
			defaultY = 50,
			overSrc = "stage2Button.png",
			overX = 100,
			overY = 50,
			onEvent = onStage2Touch,
			id = "stage2Button",
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		stage2Button.x = (display.contentWidth * .5) - 75
		stage2Button.y = (display.contentHeight * .5) + 75
		
		l1StageSelectionGroup:insert(stage2Button)
		
		
		
		--STAGE THREE BUTTON
		local stage3Button
		
		local onStage3Touch = function(event)
		
			if event.phase == "release" and stage3Button.isActive then
			
				screenManager:changeScene("l1s3Load")
				
			end
		end
		
		stage3Button = ui.newButton{
			defaultSrc = "stage3Button.png",
			defaultX = 100,
			defaultY = 50,
			overSrc = "stage3Button.png",
			overX = 100,
			overY = 50,
			onEvent = onStage3Touch,
			id = "stage3Button",
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		stage3Button.x = (display.contentWidth * .5) - 75
		stage3Button.y = (display.contentHeight * .5) + 150
		
		l1StageSelectionGroup:insert(stage3Button)
		
		
		
		--BACK BUTTON
		local backButton
		
		local onBackTouch = function(event)
		
			if event.phase == "release" and backButton.isActive then
			
				screenManager:changeScene("levelSelection")
				
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
		
		backButton.x = (display.contentWidth * .5) + 75
		backButton.y = (display.contentHeight * .5)
		
		l1StageSelectionGroup:insert(backButton)
	
	end
	
	drawScreen()
	
	clean = function()
	
	end
	
	return l1StageSelectionGroup
end
	
	