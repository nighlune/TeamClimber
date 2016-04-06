---------------------------------------------------------------------------------------------------------
--									CURRENT CODE FOR STAGE 1, LEVEL 1
---------------------------------------------------------------------------------------------------------
--[[ stage 1, level 1 ]]--

module(..., package.seeall)

function new()	
	
	---------------------------------------------------------------------------------------------------------
	--STAGE VARIABLES
	---------------------------------------------------------------------------------------------------------
	local screenOverlay
	
	
	local gameIsActive = false
	local canSwipe = true
	
	local waitingForNewRound
	local restartTimer
	local gameRunning = true
	
	local gameIsOver = false
	---------------------------------------------------------------------------------------------------------
	--END STAGE VARIABLES
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--BUTTONS (where applicable)
	---------------------------------------------------------------------------------------------------------
	local pauseButton
	local pauseMenuButton
	---------------------------------------------------------------------------------------------------------
	--END BUTTONS
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--DISPLAY GROUPS
	---------------------------------------------------------------------------------------------------------
	local l1s1Group = display.newGroup()
	local HUDGroup = display.newGroup()
	
	local levelGroup = display.newGroup()
	local boulderGroup = display.newGroup()
	local powerUpGroup = display.newGroup()
	---------------------------------------------------------------------------------------------------------
	--END DISPLAY GROUPS
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--LIBRARIES
	---------------------------------------------------------------------------------------------------------
	require "climber"
	
	local physics = require("physics")
	local ui = require("ui")
	---------------------------------------------------------------------------------------------------------
	--END LIBRARIES
	---------------------------------------------------------------------------------------------------------

	
	
	---------------------------------------------------------------------------------------------------------
	--PLATFORM
	---------------------------------------------------------------------------------------------------------
	local platformPhysics = {density = 1.0, friction = 0.3, bounce = 0.0}
	local platformID = 1

	-- Platform variable --
	local platform = display.newImage( "platform.png" )
	platform.myName = "platform"
	platform.isVisible = false
	local ogLength = platform.width
	local platformExists = true
	
	l1s1Group:insert(platform)
	l1s1Group:insert(HUDGroup)
	
	-- A function that removes the platform safely --
	function removePlatform()
		if ( platformExists == true ) then
			platform:removeSelf()
			platformExists = false
		end
	end
	
	function determineBounce()
		return 400 - ( platformID * 50 )
	end

	-- An event for when the screen is swiped --
	function platform:touch( event )
			
		-- The end of the swipe event, so a line is made --
		if( event.phase == "ended" ) then
			
			-- Check to see whether or not click was on the button or in the top 2/3 of screen--
			if ( event.y > ( ( display.contentHeight / 3 ) * 2 ) ) then
				
				--if(gameRunning == true) then
				if(gameIsActive == true) then
				
					-- A line that represents the users swipe --
					line = display.newLine( event.xStart, event.yStart, event.x, event.y )
					line.isVisible = false
					lineLength = line.contentWidth
					
					-- Reset all values to default platform value --
					removePlatform()
					
					if( lineLength < ogLength ) then
						platform = display.newImage( "platform.png" )
						platform.myName = "platform"
						platformID = 1
					elseif ( lineLength < ogLength * 2 ) then
						platform = display.newImage( "platform_x2.png" )
						platform.myName = "platform"
						platformID = 2
					elseif ( lineLength < ogLength * 3 ) then
						platform = display.newImage( "platform_x3.png" )
						platform.myName = "platform"
						platformID = 3
					else
						platform = display.newImage( "platform_x4.png" )
						platform.myName = "platform"
						platformID = 4
					end
					
					platformExists = true		
					platform.isVisible = false
					platform.xScale = 1
					platform.xReference = - ( platform.width / 2 )
					length = platform.contentWidth
					-------- End of Reset platform variables ----------
					
					-- Platform's physic values --
					physics.addBody( platform , "static", platformPhysics)
					
					-- Draw the platform in the correct direction --
					if ( event.xStart < event.x ) then
						platform.x = event.xStart 
					else
						platform.xReference = platform.xReference + platform.width
						platform.x = event.xStart
					end
					
					platform.y = event.yStart + ( platform.height / 2 )
					platform.isVisible = true
					
					l1s1Group:insert(platform)
					l1s1Group:insert(HUDGroup)
				end
			end
		end
	end
	---------------------------------------------------------------------------------------------------------
	--END PLATFORM
	---------------------------------------------------------------------------------------------------------

	
	
	---------------------------------------------------------------------------------------------------------
	--COLLISION
	---------------------------------------------------------------------------------------------------------
	function onCollision( event )
		
		if ( event.phase == "began" ) then
			if((event.object1.myName == "platform" and event.object2.myName == "boulder") or (event.object1.myName == "boulder" and event.object2.myName == "platform")) then
				removePlatform()
			end
			
			if(event.object1.myName == "Climber" and event.object2.myName == "boulder") then
				removeObject(event.object2)
			elseif(event.object1.myName == "boulder" and event.object2.myName == "Climber") then
				removeObject(event.object1)
			end
			
			if((event.object1.myName == "platform" and event.object2.myName == "Climber") or (event.object1.myName == "Climber" and event.object2.myName == "platform")) then
				climber.image:setLinearVelocity( 0, -determineBounce() )
			end
			
			if(event.object1.myName == "pit" and event.object2.myName ~= "Climber") then
				removeObject(event.object2)
				gameIsOver = true
			elseif(event.object2.myName == "pit" and event.object1.myName ~= "Climber") then
				removeObject(event.object1)
			end
			
		elseif ( event.phase == "ended" ) then
			if((event.object1.myName == "platform" and event.object2.myName == "Climber") or (event.object1.myName == "Climber" and event.object2.myName == "platform")) then
				removePlatform()
			end
		end
	end
	---------------------------------------------------------------------------------------------------------
	--END COLLISION
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--ACCELEROMETER
	---------------------------------------------------------------------------------------------------------
	local lastXGrav = 0

	function onTilt(event)
		
		-- Current Boy's X and Y velocity
		vx, vy = climber.image:getLinearVelocity()
			
		-- Dead Zone
		if( event.xGravity > 0.1 and event.xGravity < -0.1 ) then
			
			climber.image:setLinearVelocity( 0,  vy )
		
		-- Instantaneous move to opposite direction
		elseif( ( ( lastXGrav - event.xGravity ) > 0.03 ) or  ( ( event.xGravity - lastXGrav ) > 0.03 ) ) then
		
			if( lastXGrav > event.xGravity ) then
				climber.image:setLinearVelocity( -100,  vy )
			else
				climber.image:setLinearVelocity( 100,  vy )
			end
		
		else
		
			climber.image:applyLinearImpulse( 10 * event.xGravity, 0, climber.image.x, climber.image.y )
			
		end
		
		-- Max X velocity
		if( vx > 180 ) then
			climber.image:setLinearVelocity( 180, vy )
		elseif( vx < -180 ) then
			climber.image:setLinearVelocity( -180,  vy )
		end
		
		lastXGrav = event.xGravity
		
	end
	---------------------------------------------------------------------------------------------------------
	--END ACCELERTOMETER
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--SPAWN MANAGER
	---------------------------------------------------------------------------------------------------------
	local boulderPhysics = {density = 1.0, friction = 0.0, bounce = 0.2}
	local powerUpPhysics = {density = 1.0, friction = 2.0, bounce = 0.0}
	local pitPhysics = {density = 1.0, friction = 0.3, bounce = 0.2}
	local boulders = {}
	local powerUps = {}
	local pit = display.newRect( 0, 0, display.contentWidth * 4, 1)
	local boulderTimerInterval = 1000
	local powerUpTimerInterval = 3000
	local timerActive = false
	local gamePaused = false
	local boulderTimer
	
		
	function startTimer()
		timerActive = true
		addBoulder()		
		addPowerUp()
		boulderTimer = timer.performWithDelay(boulderTimerInterval, function(event) addBoulder() end, 0)
		powerUpTimer = timer.performWithDelay(powerUpTimerInterval, function(event) addPowerUp() end, 0)
	end

	function initializePowerUps()
		local powerUpRocket = {}
		powerUpRocket.solid = "rocket.png"
		powerUpRocket.myName = "grapplingHook";
		table.insert( powerUps, powerUpRocket)
		
	end
	
	function initializeBoulders()
		local boulder1 = {}
		boulder1.solid = "boulder.png"
		boulder1.myName = "boulder"
		table.insert( boulders, boulder1 )
	
		local boulder2 = {}
		boulder2.solid = "button.png"
		boulder2.myName = "boulder"
		table.insert( boulders, boulder2 )
	
		local boulder3 = {}
		boulder3.solid = "coffee_pot.jpg"
		boulder3.myName = "boulder"
		table.insert( boulders, boulder3 )
		
	end

	function getPowerUp()
		local powerUpTemp = powerUps[math.random(1, #powerUps)]
		local powerUp = display.newImage(powerUpTemp.solid)
		powerUp.solid = powerUpTemp.solid
		powerUp.myName = powerUpTemp.myName
		return powerUp
	end
	
	function getBoulder()
		local boulderTemp = boulders[math.random(1, #boulders)]
		local boulder = display.newImage(boulderTemp.solid)
		boulder.solid = boulderTemp.solid
		boulder.myName = boulderTemp.myName
		return boulder
	end

	function addBoulder()
		
		if timerActive and gameIsActive then
			
			local object = getBoulder()
		
			boulderGroup:insert(object)
			object.y = -100
			local x = math.random(0,10) * .1
			object.x = display.contentWidth * x
		
			boulderPhysics.radius = object.height / 2
			physics.addBody(object, "dynamic", boulderPhysics)
			
			--needed to set the draw orders so powerups are drawn before HUD
			l1s1Group:insert(boulderGroup)
			l1s1Group:insert(HUDGroup)
			
		end		
	end

	function addPowerUp()
	
		if timerActive and gameIsActive then
			local object = getPowerUp()
			powerUpGroup:insert(object)
			object.y = -100
			local x = math.random(0,10) * .1
			object.x = display.contentWidth * x
		
			powerUpPhysics.radius = object.height / 2
			physics.addBody(object, "dynamic", powerUpPhysics)
			
			--needed to set the draw orders so powerups are drawn before HUD
			l1s1Group:insert(powerUpGroup)
			l1s1Group:insert(HUDGroup)
			
		end	
	end
	
	function removeObject(object)

		object:removeSelf()
		
	end

	function createPit()

		pit.x =  (display.contentWidth / 2)
		--pit.y = display.contentHeight + display.contentHeight
		--
		pit.y = display.contentHeight * .75
		--
		pit.myName = "pit"
		physics.addBody(pit, "static", pitPhysics)
		pit.isVisible = false
		
		l1s1Group:insert( pit )
		
	end


	function cancelBoulderTimer()

		timer.cancel(boulderTimer)
		timer.cancel(powerUpTimer)
		--table.remove(boulders)
		boulderTimer = nil
		timerActive = false

	end

	function setGamePaused()

		if gamePaused then
			gamePaused = false
			
		else
			gamePaused = true
		
		end
	end
	---------------------------------------------------------------------------------------------------------
	--END SPAWN MANAGER
	---------------------------------------------------------------------------------------------------------

	
	
	---------------------------------------------------------------------------------------------------------
	--START A NEW ROUND
	---------------------------------------------------------------------------------------------------------
	local startNewRound = function()
	
		if screenOverlay then
		
			display.remove(screenOverlay)
			screenOverlay = nil
			
		end
		
		--create the climber----------------------------------------------------------
		climber = Climber:new()
		climber.image = display.newImage("explorer_rt.png", 220, 100)
		climber.image.myName = "Climber"		
		physics.addBody(climber.image, {density = 1.0, friction = 0.3, bounce = 0.0})
		climber.image.isFixedRotation = true
		
		l1s1Group:insert(climber.image)
		-------------------------------------------------------------------------------
		
		canSwipe = true
		waitingForNewRound = false
		gameIsActive = true
		
		pauseButton.isVisible = true
		pauseButton.isActive = true
		
		l1s1Group:insert(boulderGroup)
		l1s1Group:insert(powerUpGroup)
		--l1s1Group:insert(HUDGroup)
		
	end
	---------------------------------------------------------------------------------------------------------
	--END START NEW ROUND
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--GAME OVER
	---------------------------------------------------------------------------------------------------------
	local gameOver = function(isWin)
	
		local isWin = isWin
		
		gameIsActive = false
		physics.pause()
		
		pauseButton.isVisible = false
		pauseButton.isActive = false
		
		--[[
		-------------------------------------------------------------
		--if climber then
		
			climber = nil
		
		--end
		
		cancelBoulderTimer()		
		removePlatform()
		--pit:removeSelf()
		
		--remove the boulders on the screen
		for i = boulderGroup.numChildren, 1, -1 do
		
			local child = boulderGroup[i]
			child.parent:remove(child)
			child = nil
		
		end		
		
		display.remove(boulderGroup)
		boulderGroup = nil
		
		--remove the powerups on the screen		
		for i = powerUpGroup.numChildren, 1, -1 do
		
			local child = powerUpGroup[i]
			child.parent:remove(child)
			child = nil
		
		end		
		
		display.remove(powerUpGroup)
		powerUpGroup = nil
		-------------------------------------------------------------
		]]--
		
		if screenOverlay then
			
			display.remove(screenOverlay)
			screenOverlay = nil
			
		end
		
		screenOverlay = display.newRect(0, 0, 640, 960)
		screenOverlay:setFillColor(0, 0, 0, 255)
		
		screenOverlay.alpha = 0.5
		
		local gameOverDisplay
		
		--player wins
		if isWin == "yes" then
			
			gameOverDisplay = display.newImage("youWinClear.png")
		
		else
		
			gameOverDisplay = display.newImage("gameOverClear.png")
			
		end
		
		gameOverDisplay.x = (display.contentWidth * .5)
		gameOverDisplay.y = (display.contentHeight * .25)
		
		
		--MENU BUTTON (accessible after win/lose)
		local onMenuTouch = function(event)
		
			if event.phase == "release" then
			
				screenManager:changeScene("mainMenuLoad")
				
			end
		end
		
		local menuButton = ui.newButton{
			defaultSrc = "menuButtonSmall.png",
			defaultX = 50,
			defaultY = 50,
			overSrc = "menuButtonSmall.png",
			overX = 50,
			overY = 50,
			onEvent = onMenuTouch,
			id = "menuButton",
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		menuButton.x = (display.contentWidth * .5) - 25
		menuButton.y = (display.contentHeight * .5)
		--menuButton.alpha = 0
		
		
		
		--RESTART BUTTON (accessible after win/lose)
		local onRestartTouch = function(event)
		
			if event.phase == "release" then
			
				--local moduleToLoad = "load" .. restartModule
				screenManager:changeScene("l1s1Load") --change this to appropriate level
				
			end
		end
		
		local restartButton = ui.newButton{
			defaultSrc = "restartButtonSmall.png",
			defaultX = 50,
			defaultY = 50,
			overSrc = "restartButtonSmall.png",
			overX = 50,
			overY = 50,
			onEvent = onRestartTouch,
			id = "restartButton",
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		restartButton.x = (display.contentWidth * .5) - 130
		restartButton.y = (display.contentHeight * .5)
		--restartButton.alpha = 0
		
		
		
		--NEXT STAGE BUTTON
		local onNextTouch = function(event)
		
			if event.phase == "release" then
			
				--local moduleToLoad = "load" .. nextModule
				screenManager:changeScene("l1s2Load") --change this to appropriate level
				
			end
		end
		
		local nextButton = ui.newButton{
			defaultSrc = "nextButtonSmall.png",
			defaultX = 50,
			defaultY = 50,
			overSrc = "nextButtonSmall.png",
			overX = 50,
			overY = 50,
			onEvent = onNextTouch,
			id = "NextButton",
			text = "",
			font = "Arial",
			textColor = {255, 255, 255, 255},
			size = 16,
			emboss = false
		}
		
		nextButton.x = (display.contentWidth * .5) + 80
		nextButton.y = (display.contentHeight * .5)
		--nextButton.alpha = 0
		
		if isWin ~= "yes" then nextButton.isVisible = false; end
		
		--openfeint button
		
		--facebook button
		
		--insert elements into group
		
		HUDGroup:insert(screenOverlay)		
		HUDGroup:insert(gameOverDisplay)		
		HUDGroup:insert(menuButton)
		HUDGroup:insert(restartButton)
		
		if isWin == "yes" then
		
			HUDGroup:insert(nextButton)
		
		end
		
		--screenOverlay = 0.5
		
		--fade in elements
		--transition.to(screenOverlay, {time = 200, alpha = .5})
		
		--update best score (if applicable)
		
		--
		--l1s1Group:insert(HUDGroup)
		--
		
	end
	---------------------------------------------------------------------------------------------------------
	--END GAME OVER
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--CALL NEW ROUND
	---------------------------------------------------------------------------------------------------------
	local callNewRound = function()
	
	end
	---------------------------------------------------------------------------------------------------------
	--END CALL NEW ROUND
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--DRAW BACKGROUND
	---------------------------------------------------------------------------------------------------------
	local drawBackground = function()
	
		--local backgroundImage = display.newImage("stage1Screen.png")
		local backgroundImage = display.newImage("mountain_snow.png")
		
		l1s1Group:insert(backgroundImage)
		
		--
		l1s1Group:insert(boulderGroup)
		l1s1Group:insert(powerUpGroup)
		l1s1Group:insert(HUDGroup)
		--
		
	end
	---------------------------------------------------------------------------------------------------------
	--END DRAW BACKGROUND
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--DRAW HEADS UP DISPLAY
	---------------------------------------------------------------------------------------------------------
	local drawHUD = function()
				
		local onPauseTouch = function(event)
		
			if event.phase == "release" and pauseButton.isActive then
			
				setGamePaused()
		
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
						
						l1s1Group:insert(boulderGroup)
						l1s1Group:insert(powerUpGroup)
						l1s1Group:insert(HUDGroup)
						--l1s1Group:insert(screenOverlay)
					
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
			
				screenManager:changeScene("l1s1Load")
			
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
		
		--
		--l1s1Group:insert(boulderGroup)
		--l1s1Group:insert(powerUpGroup)
		--l1s1Group:insert(HUDGroup)
		--
		
	end
	
	--local health = 1500;
	--local barWidth = 300;
	--local myNewRatio = (barWidth/health);
	--local myNewHealth = barWidth;
	--local halfHealth = (health/2*myNewRatio);

	--display.setStatusBar( display.HiddenStatusBar )


	--[[
	function healthBar()

		halfW = display.contentWidth 
		halfH = display.contentHeight 
		function moveHealth()
		
			myNewHealth = health*myNewRatio;
			adjustHealth =( myNewRatio*.5 )
			
			--local myRectangle = display.newRect( 0 , 0, barWidth , 24 ) 
			--myRectangle.strokeWidth = 2 
			--myRectangle:setFillColor( 0 , 0 , 0 ) 
			--myRectangle:setStrokeColor( 255 , 255 , 255)
	 
			--myRectangle.x = halfW ;
			--myRectangle.y = halfH ;
			
			if ( myNewHealth <= halfHealth ) then
				local myRectangle2 = display.newRect( 0 , 0, myNewHealth , 24 ) 
				myRectangle2.strokeWidth = 2 
				myRectangle2:setFillColor(255 , 0 , 0 ) 
				myRectangle2:setStrokeColor( 255 , 255 , 255)
				myRectangle2.x = halfW-halfHealth+(health*adjustHealth);
				myRectangle2.y = halfH ;
				 
			else
				local myRectangle2 = display.newRect( 0 , 0, myNewHealth , 24 ) 
				myRectangle2.strokeWidth = 2 
				myRectangle2:setFillColor( 0 , 255 , 0 ) 
				myRectangle2:setStrokeColor( 255 , 255 , 255)
				myRectangle2.x = halfW-halfHealth+(health*adjustHealth);
				myRectangle2.y = halfH ;
				 
			end
			
			
			
		end
		]]--

		
		--[[local t = display.newText( "0", 40, 40, native.systemFont, 18 );
		t.xScale =.5; t.yScale =.5; 
		t:setTextColor( 255,255, 255 );]]--
		
--[[		
		moveHealth() 
	end

	function gainHealth()
		health = health + 100
		moveHealth()
	end

	function loseHealth()
		health = health - 10
		moveHealth()
		if(health < 0) then
			--print("we have died")
			---health = 500
		end
	end	
	]]--
	
	---------------------------------------------------------------------------------------------------------
	--END DRAW HEADS UP DISPLAY
	---------------------------------------------------------------------------------------------------------
	
	
	--ON SCREEN TOUCH FUNCTION
	local onScreenTouch = function(event)
	
		if gameIsActive then
		
		end	
	end
	
	
	
	--create functions (where applicable)
		
	
	---------------------------------------------------------------------------------------------------------
	--GAME LOOP FUNCTION
	---------------------------------------------------------------------------------------------------------
	local gameLoop = function()
		
		if gameIsOver then
			gameOver("yes")
		end
		
		if gameIsActive then
			--loseHealth()
		end	
	end
	---------------------------------------------------------------------------------------------------------
	--END GAME LOOP FUNCTION
	---------------------------------------------------------------------------------------------------------
	
	
	--create level function
	
	
	---------------------------------------------------------------------------------------------------------
	--ON SYSTEM FUNCTION
	---------------------------------------------------------------------------------------------------------
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
	---------------------------------------------------------------------------------------------------------
	--END ON SYSTEM FUNCTION
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--GAME INITIALIZE FUNCTION
	---------------------------------------------------------------------------------------------------------
	local gameInit = function()
	
		physics.start(true)
		
		drawBackground()
		drawHUD()
		
		startNewRound()
		
		--------------------------------------------------
		initializeBoulders()
		initializePowerUps()
		--healthBar()
		createPit()
		startTimer()
		--------------------------------------------------
		
		Runtime:addEventListener("touch", onScreenTouch)
		Runtime:addEventListener("enterFrame", gameLoop)
		Runtime:addEventListener("system", onSystem)
		Runtime:addEventListener("touch", platform)
		Runtime:addEventListener( "collision", onCollision )
		Runtime:addEventListener("accelerometer", onTilt)
		
	end
	---------------------------------------------------------------------------------------------------------
	--END GAME INITIALIZE FUNCTION
	---------------------------------------------------------------------------------------------------------
	
	
	
	---------------------------------------------------------------------------------------------------------
	--CLEAN FUNCTION
	---------------------------------------------------------------------------------------------------------
	clean = function()
	
		physics.stop()
		
		--remove game objects------------------------------------
		--climber:delete()
		climber = nil
		
		cancelBoulderTimer()
		
		gameIsActive = false
		removePlatform()
		pit:removeSelf()
	
		---------------------------------------------------------
		
		
		Runtime:removeEventListener("touch", onScreenTouch)
		Runtime:removeEventListener("enterFrame", gameLoop)
		Runtime:removeEventListener("system", onSystem)
		Runtime:removeEventListener("touch", platform)
		Runtime:removeEventListener( "collision", onCollision )
		Runtime:removeEventListener("accelerometer", onTilt)
		
		--removing boulder group		
		if boulderGroup then
		
			for i = boulderGroup.numChildren, 1, -1 do
		
				local child = boulderGroup[i]
				child.parent:remove(child)
				child = nil
			end
			
			display.remove(boulderGroup)
			boulderGroup = nil
		
		end	
		
		--removing powerup group
		if powerUpGroup then
		
			for i = powerUpGroup.numChildren, 1, -1 do
		
				local child = powerUpGroup[i]
				child.parent:remove(child)
				child = nil
		
			end		
			
			display.remove(powerUpGroup)
			powerUpGroup = nil
		
		end
		
		--removing HUD group
		--[[
		for i = HUDGroup.numChildren, 1, -1 do
		
			local child = HUDGroup[i]
			child.parent:remove(child)
			child = nil
		
		end
		
		display.remove(HUDGroup)
		HUDGroup = nil
		]]--
		
		--removing level group (if applicable)
		if levelGroup then
		
			display.remove(levelGroup)
			levelGroup = nil
			
		end

		--stop animations/transitions
		--stop any timers
		--clean the sounds
	end
	---------------------------------------------------------------------------------------------------------
	--END CLEAN FUNCTION
	---------------------------------------------------------------------------------------------------------
	
	gameInit()
	
	--to test transitions
	--gameTimer = timer.performWithDelay(3000, function() gameOver("yes"); end, 1)
	
	return l1s1Group
	
end	
	