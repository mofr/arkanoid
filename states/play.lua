local main = gs.new()

local menu = require 'game.game_menu'
local in_menu = false

local particle = g.newImage('media/flare.png')
local part1 = g.newImage('media/part1.png');
local explosions = {}

local gravity = true
local grid_visible = false

paddle = Paddle()

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
	game.level.first()
end

function main:leave()
end

function main:keypressed(key)
	if in_menu then
		menu:keypressed(key)
	else
		if key == 'escape' or key == 'p' then menu_enter() end
		if key == 'g' then gravity = not gravity end
		if key == 't' then grid_visible = not grid_visible end
	end
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

	--paddle position
	paddle:moveTo(love.mouse.getX())

	--paddle pole
	if love.mouse.isDown('l') then
		paddle.pole = -1
	elseif love.mouse.isDown('r') then
		paddle.pole = 1
	else
		paddle.pole = 0
	end

	for i, ball in ipairs(game.level.balls) do
		if gravity then
			local dx = paddle.x+paddle.w/2 - ball:getX()
			local dy = paddle.y - ball:getY()
			if math.abs(dx) < 5 then dx = 500 end
			if math.abs(dy) < 5 then dy = 500 end
			local d = math.sqrt(dx*dx+dy*dy)
			local koef = -0.3*ball.m*paddle.m/d/d * ball.pole*paddle.pole
			local fx = dx*koef
			local fy = dy*koef
			ball.phys.b:applyForce(fx, fy)
		end
	
		if ball.ps then
			ball.ps:setPosition(ball:getX(), ball:getY())
			ball.ps:update(dt)
		end
	end

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

local function draw_effects()
	for _, e in ipairs(explosions) do g.draw(e, 0, 0) end
end

function main:draw()
	if grid_visible then draw_grid() end
	game.level.draw()
	paddle:debugDraw()
	draw_effects()

	if in_menu then menu:draw() end
end

return main
