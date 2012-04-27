local main = gs.new()

local menu = require 'game/game_menu'
local in_menu = false

local particle = g.newImage('media/flare.png')
local part1 = g.newImage('media/part1.png');
local explosions = {}

local gravity = true
local grid_visible = false

local balls = {}

local board = {}
board.x = 0
board.y = 0
board.w = 100
board.m = 3000
board.pole = 0

local function reset()
	balls = {}
	board.x = g.getWidth()/2

	local ball = newBall()
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
	ball = newBall()
	ball.x = 500
	ball.velx = 0--120
	ball.vely = 0--200
	ball.ps = newBallPS()
	ball.m = 1	
	ball.pole = -1
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

	game.level.first()
end


function menu_enter()
	in_menu = true
	menu:enter()
end

function menu.resume()
	in_menu = false
	love.mouse.setVisible(false)
	love.mouse.setGrab(true)
end

function menu.exit()
	gs.switch(game.state.menu)
end

function main:init()
end

function main:enter()
	in_menu = false
	love.mouse.setVisible(false)
	love.mouse.setGrab(true)
	reset()
end

function main:leave()
end

function main:keypressed(key)
	if in_menu then
		menu:keypressed(key)
	else
		if key == 'escape' then menu_enter() end
		if key == 'g' then gravity = not gravity end
		if key == 't' then grid_visible = not grid_visible end
	end
end

function newBall(x, y, velx, vely, r, m)
	local ball = {}
	table.insert(balls, ball)

	r = r or 10

	ball.x = x or 100
	ball.y = y or 100
	ball.velx = velx or 0
	ball.vely = vely or 0
	ball.r = r
	ball.m = m or 400
	ball.pole = 0
	ball.ax = 0
	ball.ay = 0

	ball.phys = {}
	ball.phys.b = love.physics.newBody(game.world, ball.x, ball.y, 'dynamic')
	ball.phys.b:setMass(10)
	ball.phys.s = love.physics.newCircleShape(r)
	ball.phys.f = love.physics.newFixture(ball.phys.b, ball.phys.s)
	ball.phys.f:setFriction(0)
	ball.phys.f:setRestitution(1)
--	ball.phys.b:applyLinearImpulse(230, 230)

	return ball
end

function newBallPS()
	p = g.newParticleSystem(particle, 1500)
	p:setPosition(100, 100)
	p:setEmissionRate(350)
--	p:setLifetime(2)
	p:setSizes(0.5, 0.3, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
	p:setTangentialAcceleration(-100.0, 100.0)
	p:setSpeed(50, 100)
	p:setParticleLife(1.0)
	p:setSpin(1)
	p:setSpread(360)
	p:setColors(120,130,255,255, 200,200,255,255, 200,200,255,255)
	p:start()
	return p
end

function newExplosion(x, y, dir, power)
	power = power or 0.5
	if power > 1 then power = 1 end
	p = g.newParticleSystem(part1, 1000)
	table.insert(explosions, p)
	p:setEmissionRate(1000 * power)
	p:setSpeed(400 - 400*power, 600*power)
	p:setSizes(1, 0.5)
	p:setColors(220, 105, 20, 255*power, 194, 30, 18, 0)
	p:setPosition(x, y)
	p:setLifetime(0.15*power)
	p:setParticleLife(0.1 + 0.1 * power)
	p:setDirection(dir or 0)
	p:setSpread(2)
	p:setTangentialAcceleration(-1000, 1000)
	p:setRadialAcceleration(-1000 * power)
	p:setGravity(2000)
	p:start()
end

--returns p1 gravity force to p2
function calcGravity(p1, p2)
	local dx = p2.x - p1.x
	local dy = p2.y - p1.y
	if math.abs(dx) < 5 then dx = 500 end
	if math.abs(dy) < 5 then dy = 500 end
	local d = math.sqrt(dx*dx+dy*dy)
	local koef = -150*p1.m*p2.m/d/d * p1.pole*p2.pole
	local ax = dx*koef
	local ay = dy*koef

	return ax, ay
end

local function update_level(dt)
	local w = g.getWidth()
	local h = g.getHeight()

	--board position
	board.y = h
	board.x = love.mouse.getX()-board.w/2
	if board.x < 0 then board.x = 0 end
	if board.x+board.w > w then board.x = w-board.w end

	--board pole
	if love.mouse.isDown('l') then
		board.pole = -1
	elseif love.mouse.isDown('r') then
		board.pole = 1
	else
		board.pole = 0
	end

	for i, ball in ipairs(balls) do
		if gravity then
			local dx = board.x - ball.phys.b:getX()
			local dy = board.y - ball.phys.b:getY()
			if math.abs(dx) < 5 then dx = 500 end
			if math.abs(dy) < 5 then dy = 500 end
			local d = math.sqrt(dx*dx+dy*dy)
			local koef = -0.3*ball.m*board.m/d/d * ball.pole*board.pole
			local fx = dx*koef
			local fy = dy*koef
			ball.phys.b:applyForce(fx, fy)
		end
	
		if ball.ps then
			ball.ps:setPosition(ball.phys.b:getX(), ball.phys.b:getY())
			ball.ps:update(dt)
		end
	end
--[[	
	--balls
	for i, ball in ipairs(balls) do
		--apply gravity to acceleration
		ball.ax = 0
		ball.ay = 0
		if gravity then
			local ax
			local ay
			for k, ball2 in ipairs(balls) do
				if k ~= i then
					ax, ay = calcGravity(ball, ball2)
					ball.ax = ball.ax + ax
					ball.ay = ball.ay + ay
				end
			end

			ax, ay = calcGravity(ball, board)

			ball.ax = ball.ax + ax
			ball.ay = ball.ay + ay
		end

		--apply acceleration to velocity
		ball.velx = ball.velx + ball.ax*dt/ball.m
		ball.vely = ball.vely + ball.ay*dt/ball.m

		--limit velocity
		if ball.velx > w then ball.velx = w end
		if ball.vely > h then ball.vely = h end
		
		--apply velocity to position
		ball.x = ball.x + dt*ball.velx
		ball.y = ball.y + dt*ball.vely

		--check collisions
		local powerx = math.abs(ball.velx) / 500
		local powery = math.abs(ball.vely) / 500
		if ball.x-ball.r <= 0 then 
			ball.x = ball.r; ball.velx = -ball.velx; 
			newExplosion(0, ball.y, 0, powerx)
		end
		if ball.y-ball.r <= 0 then 
			ball.y = ball.r; ball.vely = -ball.vely;
			newExplosion(ball.x, 0, math.pi/2, powery)
		end
		if ball.x+ball.r >= w then 
			ball.x = w-ball.r; ball.velx = -ball.velx;
			newExplosion(w, ball.y, math.pi, powerx)
		end
		if ball.y+ball.r >= h then 
			ball.y = h-ball.r; ball.vely = -ball.vely;
			newExplosion(ball.x, h, -math.pi/2, powery)
		end

		if ball.ps then
			ball.ps:setPosition(ball.x, ball.y)
			ball.ps:update(dt)
		end
	end
]]
	--remove old explosions
	for i, e in ipairs(explosions) do 
		if not e:isActive() then
			table.remove(explosions, i)
		else
			e:update(dt) 
		end
	end

	game.level.update(dt)
	game.world:update(dt)
end

function main:update(dt)
	if in_menu then 
		menu:update(dt)
	else
		update_level(dt)
	end
end

local function draw_grid()
	g.setColor(255,255,255, 32)
	for x = 0, g.getWidth(), 16 do
		g.line(x, 0, x, g.getHeight())
	end
	for y = 0, g.getHeight(), 16 do
		g.line(0, y, g.getWidth(), y)
	end
end

local function draw_balls()
	for _, ball in ipairs(balls) do
		if ball.ps then
			g.setBlendMode("additive")
			g.draw(ball.ps, 0, 0)
		else
			if ball.pole == 1 then
				g.setColor(255, 0, 0)
			elseif ball.pole == -1 then
				g.setColor(0, 0, 255)
			else
				g.setColor(255, 255, 255)
			end
			g.circle("fill", ball.phys.b:getX(), ball.phys.b:getY(), ball.r, 32)
--			g.line(ball.x, ball.y, ball.x+ball.ax, ball.y+ball.ay)
		end
	end
end

local function draw_board()
	if board.pole == 1 then
		g.setColor(255, 0, 0)
	elseif board.pole == -1 then
		g.setColor(0, 0, 255)
	else
		g.setColor(255, 255, 255)
	end
	g.rectangle("fill", board.x, board.y-16, board.w, 16)
end

local function draw_effects()
	for _, e in ipairs(explosions) do g.draw(e, 0, 0) end
end

local function draw_level()
	if grid_visible then draw_grid() end
	game.level.draw()
	draw_board()
	draw_balls()
	draw_effects()
end

function main:draw()
	draw_level()

	g.setColor(255,255,255)
--	love.graphics.circle("fill", ball.b:getX(),ball.b:getY(), ball.s:getRadius())
--	love.graphics.polygon("line", floor.b:getWorldPoints(floor.s:getPoints()))
	love.graphics.line(outline.b:getWorldPoints(outline.s:getPoints()))
end

return main
