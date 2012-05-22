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

local Ball = require 'game.ball'
local Block = require 'game.block'
local Area = require 'game.level_area'
local Floor = require 'game.level_floor'
local Death = require 'game.level_death'
local LevelWin = require 'game.level_win'

level.win = LevelWin()
level.death = Death()
level.timer = Timer()
level.area = Area(10, 10, g.getWidth()-10, g.getHeight()-30)
level.floor = Floor(level.area.bottom-3)

local balls = {}
function level.balls()
	local i = 0
	local n = #balls
	return function ()
		i = i + 1
		if i <= n then return balls[i] end
	end
end
function level.ballsCount()
	return #balls
end

local blocks = {}
function level.blocks()
	local i = 0
	local n = #blocks
	return function ()
		i = i + 1
		if i <= n then return blocks[i] end
	end
end
function level.blocksCount()
	return #blocks
end


function reset_blocks()
	for block in level.blocks() do
		block:destroy()
	end
	blocks = {}
end

function reset_balls()
	for ball in level.balls() do
		ball:destroy()
	end
	balls = {}
end

function level.reset()
	level.win:reset()
	level.death:reset()
	level.timer:clear()
	reset_blocks()
end

function level.add_block(...)
	local block = Block(...)
	table.insert(blocks, block)
	return block
end

function level.add_ball(...)
	local ball = Ball(...)
	table.insert(balls, ball)
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
			gs.switch(state.main_menu)
		end
	end
end

function level.update(dt)
	level.timer:update(dt)
	level.win:update(dt)
	level.death:update(dt)

	for ball in level.balls() do
		ball:update(dt)
	end

	local block
	for i = #blocks, 1, -1 do
		block = blocks[i]
		if block.dead then
			block:destroy()
			table.remove(blocks, i)
		end
	end

	local ball
	for i = #balls, 1, -1 do
		ball = balls[i]
		if ball.dead then
			ball:destroy()
			table.remove(balls, i)
		end
	end
end

function level.draw()
	for block in level.blocks() do
		block:draw()
	end

	for ball in level.balls() do
		ball:draw()
	end

	level.win:draw()
	level.death:draw()

	level.area:debugDraw()
	level.floor:debugDraw()
end

return level
