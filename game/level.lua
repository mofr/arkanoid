local level = {}

local levels = {'1', '2'}

-- level instances
local __NULL__ = function() end
function level.new()
	return {
		enter = __NULL__,
		leave = __NULL__
	}
end

local current = level.new()
local current_index
--

local Area = require 'game.level_area'
local Floor = require 'game.level_floor'
local Death = require 'game.level_death'
local LevelWin = require 'game.level_win'

level.win = LevelWin()
level.death = Death()
level.blocks = {}
level.balls = {}
level.timer = Timer()
level.area = Area(10, 10, g.getWidth()-10, g.getHeight()-30)
level.floor = Floor(g.getHeight()-40)

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
	level.win:reset()
	level.death:reset()
	level.timer:clear()
	reset_blocks()
end

function level.add_block(...)
	local block = Block(...)
	table.insert(level.blocks, block)
	return ball
end

function level.add_ball(...)
	local ball = Ball(...)
	table.insert(level.balls, ball)
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

function level.respawn()
	reset_balls()

	local ball = level.add_ball(g.getWidth()/2, g.getHeight()*4/5)
	ball.pole = 1
end

function level.first()
	level.respawn()
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
			gs.switch(state.menu)
		end
	end
end

local min_vel = 50

function level.update(dt)
	level.timer:update(dt)
	level.win:update(dt)
	level.death:update(dt)

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

	local ball
	for i = #level.balls, 1, -1 do
		ball = level.balls[i]
		if ball.dead then
			ball:destroy()
			table.remove( level.balls, i )
		end
	end
end

local function draw_blocks()
	g.setColor(255,255,255)
	for _, block in ipairs(level.blocks) do
		block:draw()
	end
end

local function draw_balls()
	for _, ball in ipairs(level.balls) do
		ball:draw()
	end
end

function level.draw()
	draw_blocks()
	draw_balls()

	level.win:draw()
	level.death:draw()

	level.area:debugDraw()
	level.floor:debugDraw()
end

return level
