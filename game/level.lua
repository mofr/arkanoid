local level = {}

local levels = {'1', '2', '3', '4'}

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

local Area = require 'game.level_area'
local Floor = require 'game.level_floor'
local Death = require 'game.level_death'
local LevelWin = require 'game.level_win'
require 'game.level_grid'

level.win = LevelWin()
level.death = Death()
level.timer = Timer()

level.w = g.getWidth()-20
level.h = g.getHeight()-40

level.area = Area(level.w, level.h)
level.floor = Floor(level.w, level.h-5)
level.blocks = EntityList()

function level.setSize(w, h)
	level.area:destroy()
	level.w = w
	if h then level.h = h end

	level.area = Area(level.w, level.h)
	level.floor = Floor(level.w, level.h-5)
end

function level.name()
	return levels[current_index]
end

local function cleanup_level()
	level.win:reset()
	level.death:reset()
	level.timer:clear()
	level.blocks:clear()
end

local function load_level(index)
	--cleanup
	if current then current.leave() end
	cleanup_level()

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
	level.area:draw()
	level.floor:draw()

	level.win:draw()
	level.death:draw()
end

return level
