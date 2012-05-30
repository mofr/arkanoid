local level = {}

local levels = {'1', '2', '3'}

-- level instances
local __NULL__ = function() end
function level.new()
	return {
		enter = __NULL__,
		leave = __NULL__
	}
end

local current
local current_index
--

local Block = require 'game.block'
local Area = require 'game.level_area'
local Floor = require 'game.level_floor'
local Death = require 'game.level_death'
local LevelWin = require 'game.level_win'
BlockBuilder = require 'game.block_builder'

level.win = LevelWin()
level.death = Death()
level.timer = Timer()
level.area = Area(10, 10, g.getWidth()-10, g.getHeight()-30)
level.floor = Floor(level.area.bottom-5)
level.blocks = EntityList(Block)

function level.reset()
	level.win:reset()
	level.death:reset()
	level.timer:clear()
	level.blocks:clear()
end

local function load_level(index)
	--cleanup
	if current then current.leave() end
	level.reset()

	--load next
	local level_name = levels[index]
	current = require ('levels/'..level_name)
	current_index = index

	--build level
	current.enter()
end

function level.first()
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
			Gamestate.switch(state.main_menu)
		end
	end
end

function level.update(dt)
	level.timer:update(dt)

	level.blocks:update(dt)

	level.win:update(dt)
	level.death:update(dt)
end

function level.draw()
	level.blocks:draw()

	level.win:draw()
	level.death:draw()

	level.area:draw()
	level.floor:draw()
end

return level
