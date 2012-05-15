local player = {}

local Paddle = require 'game.player_paddle'
	
player.paddle = Paddle()

function player.update(dt)
	--paddle position
	player.paddle:moveTo(love.mouse.getX())

	--paddle pole
	if love.mouse.isDown('l') then
		player.paddle.pole = -1
	elseif love.mouse.isDown('r') then
		player.paddle.pole = 1
	else
		player.paddle.pole = 0
	end

	--apply paddle force to balls
	for i, ball in ipairs(game.level.balls) do
		local dx = player.paddle.x+player.paddle.w/2 - ball:getX()
		local dy = player.paddle.y - ball:getY()
		local d = math.sqrt(dx*dx+dy*dy)
		local fx, fy
		if d ~= 0 then
			local koef = -0.3*ball.m*player.paddle.m/d/d * ball.pole*player.paddle.pole
			local fx, fy = dx*koef, dy*koef
			ball.phys.b:applyForce(fx, fy)
		end
	end
end

function player.debugDraw()
	player.paddle:debugDraw()
end

return player
