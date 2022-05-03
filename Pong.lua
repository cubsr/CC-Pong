monitor = peripheral.find("monitor") --setup monitor
monitor.setTextColor(colors.red)
Player1Motion = false --checks if the playerbar is in motion
Player2Motion = false --checks if the playerbar is in motion
ballPos = {41, 17} -- the x, y of the ball
ballAngle = 0 -- the angle along the screen the ball should move
ballSpeed = .1 --speed of the ball used to modify os.sleep length
pastBallPos = {40, 17} --the x, y of the ball's last spot
p1Pos = {15, 19} --top and bottom of player 1s bar
p2Pos = {15, 19} --top and bottom of player 2s bar
term.redirect(monitor) --set output to monitor
term.setBackgroundColor(colors.black)	
local MonitorEvent -- function that repeats until a monitor press is detected
local PlayerBar1 --function that handles player ones bar
local PlayerBar2 --function that handles player twos bar
local Ball --function that handles the ball
local BallMoveLeft --function that moves the ball torward player 1
local BallMoveRight --function that moves the ball torward player 2
local MoveBar --function that moved a bar to a desired spot






MonitorEvent = function()
	local event, side, xPos, yPos
	repeat
		event, side, xPos, yPos = os.pullEvent("monitor_touch")
	until event == "monitor_touch"
	return xPos, yPos
end

PlayerBar1 = function()
	repeat
		local xPos, yPos = MonitorEvent()
		if xPos <= 41 then
			Player1Motion = true
			MoveBar(xPos, yPos)
			Player1Motion = false
		end
	until 1 == 0
end

PlayerBar2 = function()
	repeat
		local xPos, yPos = MonitorEvent()
		if xPos > 41 then
			Player2Motion = true
			MoveBar(xPos, yPos)
			Player2Motion = false
		end
	until 1 == 0
end

MoveBar = function(xPos, yPos)
	local i
	if yPos > 31 then
			yPos = 80
	elseif yPos < 2 then
		yPos = 2
	end
	if xPos <= 41 then --player 1 bar movement
		local distance = yPos - (p1Pos[1] + 2)
		if distance > 0 then --move down
			for i=0,distance do
				p1Pos = {p1Pos[1] + 1, p1Pos[2] + 1}
				paintutils.drawLine(1, p1Pos[1] - 1, 2, p1Pos[1] - 1, colors.black)
				paintutils.drawLine(1, p1Pos[2], 2, p1Pos[2], colors.white)	
				os.sleep(.2)
			end
		elseif distance < 0 then --move up
			for i=0,math.abs(distance) do
				p1Pos = {p1Pos[1] - 1, p1Pos[2] - 1}
				paintutils.drawLine(1, p1Pos[2] + 1, 2, p1Pos[2] + 1, colors.black)
				paintutils.drawLine(1, p1Pos[1], 2, p1Pos[1], colors.white)
				os.sleep(.2)
			end
		end		
	else --else is player 2 bar movement
		local distance = yPos - (p2Pos[1] + 2)
		if distance > 0 then --move down
			for i=0,distance do
				p2Pos = {p2Pos[1] + 1, p2Pos[2] + 1}
				paintutils.drawLine(81, p2Pos[1] - 1, 82, p2Pos[1] - 1, colors.black)
				paintutils.drawLine(81, p2Pos[2], 82, p2Pos[2], colors.white)	
				os.sleep(.2)
			end
		elseif distance < 0 then --move up
			for i=0,math.abs(distance) do
				p2Pos = {p2Pos[1] - 1, p2Pos[2] - 1}
				paintutils.drawLine(81, p2Pos[2] + 1, 82, p2Pos[2] + 1, colors.black)
				paintutils.drawLine(81, p2Pos[1], 82, p2Pos[1], colors.white)
				os.sleep(.2)
			end
		end	
	end
	os.sleep(.2)
end

BallMoveLeft = function()
	local saved = false
	for i = ballPos[1], 1, -1 do
		pastBallPos  = {ballPos[1], ballPos[2]}
		if (ballPos[2] + ballAngle) >= 33 then
			ballPos = {ballPos[1] - 1, 33}
			ballAngle = 0 - ballAngle			
		elseif (ballPos[2] + ballAngle) <= 1 then
			ballPos = {ballPos[1] - 1, 1}
			ballAngle = 0 - ballAngle
		else
			ballPos = {ballPos[1] - 1, ballPos[2] + ballAngle}
		end
		if ballPos[1] < 3 then
			if p1Pos[1] <= ballPos[2] and ballPos[2] <= p1Pos[2] then
				if Player1Motion then
					if ballAngle < 0 then
						ballAngle = ballAngle - 1
					else
						ballAngle = ballAngle + 1
					end
				else
					ballAngle = ballPos[2] - (p1Pos[1] + 2)
				end
				if ballAngle == 0 then
					ballSpeed = .05
				elseif ballAngle == -2 or ballAngle == -2 then
					ballSpeed = ballSpeed + .02
				else
					ballSpeed = ballSpeed + .01
				end
				ballPos = {3, ballPos[2]}
				saved = true
				break
			else
				paintutils.drawPixel(ballPos[1], ballPos[2], colors.blue)
				paintutils.drawPixel(pastBallPos[1], pastBallPos[2], colors.black)
			end
		else
			paintutils.drawPixel(ballPos[1], ballPos[2], colors.blue)
			paintutils.drawPixel(pastBallPos[1], pastBallPos[2], colors.black)
		end
		os.sleep(ballSpeed)
	end
	paintutils.drawLine(80, 1, 80, 33, colors.black)
	return saved
end

BallMoveRight = function()
	local saved = false
	for i = ballPos[1], 82, 1 do
		pastBallPos  = {ballPos[1], ballPos[2]}
		if (ballPos[2] + ballAngle) >= 33 then
			ballPos = {ballPos[1] + 1, 33}
			ballAngle = 0 - ballAngle			
		elseif (ballPos[2] + ballAngle) <= 1 then
			ballPos = {ballPos[1] + 1, 1}
			ballAngle = 0 - ballAngle
		else
			ballPos = {ballPos[1] + 1, ballPos[2] + ballAngle}
		end
		if ballPos[1] > 80 then
			if p2Pos[1] <= ballPos[2] and ballPos[2] <= p2Pos[2] then
				if Player2Motion then
					if ballAngle < 0 then
						ballAngle = ballAngle - 1
					else
						ballAngle = ballAngle + 1
					end
				else
					ballAngle = ballPos[2] - (p1Pos[1] + 2)
				end
				if ballAngle == 0 then
					ballSpeed = .05
				elseif ballAngle == -2 or ballAngle == -2 then
					ballSpeed = ballSpeed + .02
				else
					ballSpeed = ballSpeed + .01
				end
				ballPos = {80, ballPos[2]}
				saved = true
				break
			else
				paintutils.drawPixel(ballPos[1], ballPos[2], colors.blue)
				paintutils.drawPixel(pastBallPos[1], pastBallPos[2], colors.black)
			end
		else
			paintutils.drawPixel(ballPos[1], ballPos[2], colors.blue)
			paintutils.drawPixel(pastBallPos[1], pastBallPos[2], colors.black)
		end
		os.sleep(ballSpeed)
	end
	paintutils.drawLine(3, 1, 3, 33, colors.black)
	return saved
end

--This is where the game is run handling ball bounces and movement
Ball = function()
	local i
	local saved = true
	ballPos = {41, 17}
	repeat
		saved = BallMoveRight()
		if saved then
			saved = BallMoveLeft()
		end
	until saved == false
end



repeat
	local again = false
	Player1Motion = false --checks if the playerbar is in motion
	Player2Motion = false --checks if the playerbar is in motion
	ballPos = {41, 17} -- the x, y of the ball
	ballAngle = 0 -- the angle along the screen the ball should move
	ballSpeed = .1 --speed of the ball used to modify os.sleep length
	pastBallPos = {40, 17} --the x, y of the ball's last spot
	p1Pos = {15, 19} --top and bottom of player 1s bar
	p2Pos = {15, 19} --top and bottom of player 2s bar
	term.clear()
	paintutils.drawFilledBox(1, p1Pos[1], 2, p1Pos[2], colors.white)
	paintutils.drawFilledBox(81, p2Pos[1], 82, p2Pos[2], colors.white)
	paintutils.drawPixel(ballPos[1], ballPos[2], colors.blue)
	parallel.waitForAny(PlayerBar1, PlayerBar2, Ball)
	monitor.setCursorPos(39, 17)
	monitor.blit("Again?", "bbbbbb", "555555")
	local x, y = MonitorEvent()
	if 39 <= x and x <= 44 then
		if 16 <= y and y <= 18 then
			again = true
		end
	end
until again == false

