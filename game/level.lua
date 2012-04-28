local level = {}

local __NULL__ = function() end

local levels = {'1', '2', '3'}

function level.new()
	return {
		enter = __NULL__,
		leave = __NULL__
	}
end

local current = level.new()
local current_index

level.blocks = {}
level.balls = {}

function level.reset()
	level.blocks = {}
	level.balls = {}
end

function level.add_block(x, y, w, h)
	local block = {}
	table.insert(level.blocks, block)

	block.x = x
	block.y = y
	block.w = w
	block.h = h

	block.phys = {}
	block.phys.b = love.physics.newBody(game.world, x+w/2, y+h/2, 'static')
	block.phys.s = love.physics.newRectangleShape(w, h)
	block.phys.f = love.physics.newFixture(block.phys.b, block.phys.s)
	block.phys.f:setFriction(0)
	block.phys.f:setRestitution(1)
end

function level.add_ball(x, y, velx, vely, r, m)
	local ball = {}
	table.insert(level.balls, ball)

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

local function load_level(index)
	local level_name = levels[index]
	current.leave()
	level.reset()
	current = require ('levels/'..level_name)
	current.enter()
	current_index = index
end

function level.first()
	load_level(1)
end

function level.next()
	if not current_index then
		load_level(1)
	else
		load_level(current_index + 1)
	end
end

local function draw_blocks()
	g.setColor(255,255,255)
	for _, block in ipairs(level.blocks) do
		g.rectangle('fill', block.x, block.y, block.w, block.h)
	end
end

local function draw_balls()
	for _, ball in ipairs(level.balls) do
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

function level.update(dt)
end

function level.draw()
	draw_blocks()
	draw_balls()
end

return level
