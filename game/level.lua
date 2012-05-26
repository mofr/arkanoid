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
level.blocks = EntityList(Block)

function level.reset()
	level.win:reset()
	level.death:reset()
	level.timer:clear()
	level.blocks:clear()
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

	level.area:debugDraw()
	level.floor:debugDraw()
end

return level
