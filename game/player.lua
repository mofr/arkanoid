local player = {}

local Paddle = require 'game.player_paddle'
local Ball = require 'game.ball'
	
player.paddle = Paddle()
player.balls = EntityList(Ball)
player.catched_balls = {}
player.score = 0

function player.reset()
	player.score = 0
end

local function updateForces(dt)
	--paddle pole
	if love.mouse.isDown('l') then
		player.paddle.pole = -1
	elseif love.mouse.isDown('r') then
		player.paddle.pole = 1
	else
		player.paddle.pole = 0
	end

	--apply paddle force to balls
	for ball in player.balls() do
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

local function catch_balls()
	for ball in player.balls() do
		ball:disable()
		table.insert(player.catched_balls, ball)
	end
end

local function release_balls()
	for _, ball in ipairs(player.catched_balls) do
		ball:enable()
		ball.phys.b:setLinearVelocity(0, 100)
	end
end

function player.update(dt)
	player.paddle:moveTo(love.mouse.getX())
	player.balls:update(dt)

	for _, ball in ipairs(player.catched_balls) do
		ball.phys.b:setPosition(player.paddle:getX()+player.paddle:getWidth()/2, player.paddle:getY()-player.paddle:getHeight())
	end

	updateForces(dt)
end

function player.debugDraw()
	player.paddle:draw()
	player.balls:draw()
end

function player.respawn()
	player.balls:clear()

	player.balls:new{x=g.getWidth()/2, y=g.getHeight()*4/5, pole=1}

	--catch_balls()
end

return player
