local level = game.level.new()

local function create_balls()
	local ball = game.level.add_ball(g.getWidth()/2, g.getHeight()*4/5)
	ball.pole = 1
--[[
	ball = game.level.add_ball()
	ball.x = 300
	ball.velx = 0--50
	ball.vely = 0--160
	ball.pole = 1

	ball = game.level.add_ball()
	ball.x = 500
	ball.velx = 0--120
	ball.vely = 0--200
	ball.ps = newBallPS()
	ball.m = 1	
	ball.pole = -1

	ball = game.level.add_ball()
	ball.x = 600
	ball.velx = 0--120
	ball.vely = 0--200
	ball.ps = newBallPS()
	ball.m = 1	
	ball.pole = -1

	ball = game.level.add_ball()
	ball.x = 650
	ball.velx = 0--120
	ball.vely = 0--200
	ball.ps = newBallPS()
	ball.m = 1	
	ball.pole = -1]]
end

local function block_creator(w, h)
	return function(x, y)
		return game.level.add_block(x, y, w, h)
	end
end

local block_w = 80
local block_h = 40
local space = 5
local b = block_creator(block_w, block_h)

function level.enter()
	local count_x = 7
	local count_y = 7
	local left = game.level.area.w/2-count_x*(block_w+space)/2
	local top = game.level.area.h/5

	for x = 0,count_x-1 do
		for y = 0,count_y-1 do
			b(left+x*(block_w+space), top+y*(block_h+space))
		end
	end

	create_balls()
end

return level
