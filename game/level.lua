local level = {}

local __NULL__ = function() end

local levels = {'1', '2'}

function level.new()
	return {
		enter = __NULL__,
		leave = __NULL__
	}
end

local current = level.new()
local current_index

level.win = false
level.blocks = {}
level.balls = {}

function level.reset()
	level.win = false
	level.blocks = {}
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

	x = x or 100
	y = y or 100
	r = r or 10

	ball.x = x
	ball.y = y
	ball.velx = velx or 0
	ball.vely = vely or 0
	ball.r = r
	ball.m = m or 400
	ball.pole = 0
	ball.ax = 0
	ball.ay = 0

	ball.phys = {}
	ball.phys.b = love.physics.newBody(game.world, x, y, 'dynamic')
	ball.phys.b:setMass(10)
	ball.phys.s = love.physics.newCircleShape(r)
	ball.phys.f = love.physics.newFixture(ball.phys.b, ball.phys.s)
	ball.phys.f:setFriction(0)
	ball.phys.f:setRestitution(1)
--	ball.phys.b:applyLinearImpulse(230, 230)

	return ball
end

function level.is_win()
	return #level.blocks == 0
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
	level.balls = {}
	load_level(1)
end

function level.next()
	if not current_index then
		load_level(1)
	else
		local index = current_index + 1
		if index <= #levels then
			load_level(index)
		else
			gs.switch(game.state.menu)
		end
	end
end

local function draw_blocks()
	g.setColor(255,255,255)
	for _, block in ipairs(level.blocks) do
		g.rectangle('fill', block.x, block.y, block.w, block.h)
	end
end

local function draw_balls()
	local x, y
	for _, ball in ipairs(level.balls) do
		x, y = ball.phys.b:getX(), ball.phys.b:getY()
		
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
			g.circle("fill", x, y, ball.r, 32)
		end
		
		local v = vector(ball.phys.b:getLinearVelocity())
		g.setColor(255,255,255)
		g.print(v:len(), x, y-ball.r*3)
	end
end

local function check_win()
	if not level.win then
		if level.is_win() then
			level.win = true
			timer.add(3, function()
				level.next()
			end)
		end
	end
end

local min_vel = 50

function level.update(dt)
	check_win()

	--limit minimum (to avoid non-bounce collisions) and maximum balls velocity
	for _, ball in ipairs(level.balls) do
		local v = vector(ball.phys.b:getLinearVelocity())
		local len = v:len()

		if len > 1000 then
			v = v:normalized()*1000
			ball.phys.b:setLinearVelocity(v:unpack())
		else
			v = v:clone()
			if math.abs(v.x) < min_vel then v.x = min_vel*math.sign(v.x) end
			if math.abs(v.y) < min_vel then v.y = min_vel*math.sign(v.y) end
			ball.phys.b:setLinearVelocity(v:unpack())
		end
	end
end

function level.draw()
	draw_blocks()
	draw_balls()
	if level.win then
		g.setColor(255, 255, 255)
		g.print('Level complete!', g.getWidth()/2, g.getHeight()/2)
	end
end

return level
