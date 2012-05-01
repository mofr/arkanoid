local level = game.level.new()

local function block_creator(w, h)
	return function(x, y)
		return game.level.add_block(x, y, w, h)
	end
end

local b = block_creator(50, 20)

local function create_balls()
	local ball = game.level.add_ball()
	ball.x = 200
	ball.y = 200
	ball.velx = 0--300
	ball.vely = 0--300
	ball.r = 10
	ball.pole = 1
--[[
	ball = newBall()
	ball.x = 300
	ball.velx = 0--50
	ball.vely = 0--160
	ball.pole = 1
]]
--[[
	ball = game.level.add_ball()
	ball.x = 500
	ball.velx = 0--120
	ball.vely = 0--200
	ball.ps = newBallPS()
	ball.m = 1	
	ball.pole = -1
]]
--[[
	ball = newBall()
	ball.x = 600
	ball.velx = 0--120
	ball.vely = 0--200
	ball.ps = newBallPS()
	ball.m = 1	
	ball.pole = -1

	ball = newBall()
	ball.x = 650
	ball.velx = 0--120
	ball.vely = 0--200
	ball.ps = newBallPS()
	ball.m = 1	
	ball.pole = -1]]
end


function level.enter()
	b(100, 100)
	b(155, 100)
	b(210, 100)

	b(210, 125)

	create_balls()
end

return level
