local level = {}

local levels = {'1', '2'}

local __NULL__ = function() end
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
level.timer = Timer()

beginContact = __NULL__
function endContact(a, b, c)
	local d1 = a:getUserData()
	local d2 = b:getUserData()
	if d1 and d1.block then d1.block.dead = true end
	if d2 and d2.block then d2.block.dead = true end
end

function preSolve(a, b, c)
	c:setRestitution(1)
end

postSolve = __NULL__

game.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

function reset_blocks()
	for i, block in ipairs(level.blocks) do
		block:destroy()
	end
	level.blocks = {}
end

function reset_balls()
	for i, ball in ipairs(level.balls) do
		ball:destroy()
	end
	level.balls = {}
end

function level.reset()
	level.win = false
	reset_blocks()
end

function level.add_block(...)
	local block = game.block.new(...)
	table.insert(level.blocks, block)
	return ball
end

function level.add_ball(...)
	local ball = game.ball.new(...)
	table.insert(level.balls, ball)
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
	reset_balls()
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
		g.rectangle('fill', block:getX(), block:getY(), block:getSize())
	end
end

local function draw_balls()
	local x, y
	for _, ball in ipairs(level.balls) do
		x, y = ball:getPosition()
		
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
		
--		local v = vector(ball.phys.b:getLinearVelocity())
--		g.setColor(255,255,255)
--		g.print(v:len(), x, y-ball.r*3)
	end
end

local function check_win()
	if not level.win then
		if level.is_win() then
			level.win = true
			level.timer:add(3, function()
				level.next()
			end)
		end
	end
end

local min_vel = 50

function level.update(dt)
	level.timer:update(dt)
	check_win()

	--limit minimum (to avoid non-bounce collisions) and maximum balls velocity
	for _, ball in ipairs(level.balls) do
		local v = vector(ball.phys.b:getLinearVelocity())
		local len = v:len()

		if len > 1000 then
			v = v:normalized()*1000
			ball.phys.b:setLinearVelocity(v:unpack())
--		else
--			v = v:clone()
--			if math.abs(v.x) < min_vel then v.x = min_vel*math.sign(v.x) end
--			if math.abs(v.y) < min_vel then v.y = min_vel*math.sign(v.y) end
--			ball.phys.b:setLinearVelocity(v:unpack())
		end
	end

	local block
	for i = #level.blocks, 1, -1 do
		block = level.blocks[i]
		if block.dead then
			block:destroy()
			table.remove( level.blocks, i )
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
