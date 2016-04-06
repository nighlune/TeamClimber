health = 1500;
barWidth = 300;
myNewRatio = (barWidth/health);
myNewHealth = barWidth;
halfHealth = (health/2*myNewRatio);

--display.setStatusBar( display.HiddenStatusBar )

function healthBar()

	halfW = display.contentWidth * .25
	halfH = display.contentHeight * .98
	function moveHealth()
	
		myNewHealth = health*myNewRatio;
		adjustHealth =( myNewRatio*.5 )
		
		local myRectangle = display.newRect( 0 , 0, barWidth , 24 ) 
		myRectangle.strokeWidth = 2 
		myRectangle:setFillColor( 0 , 0 , 0 ) 
		myRectangle:setStrokeColor( 255 , 255 , 255)
 
		myRectangle.x = halfW ;
		myRectangle.y = halfH ;
		
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
	
	--[[local t = display.newText( "0", 40, 40, native.systemFont, 18 );
	t.xScale =.5; t.yScale =.5; 
	t:setTextColor( 255,255, 255 );]]--
		
	moveHealth() 
end

function gainHealth()
	health = health + 100
	moveHealth()
end

function loseHealth()
	health = health - 1
	moveHealth()
	if(health < 0) then
		print("we have died")
		health = 500
	end
end
