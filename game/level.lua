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

level.blocks = {}
local blocks = level.blocks

local function addBlock(x, y)
	local block = {}
	block.x = x
	block.y = y
	table.insert(blocks, block)
end

local level_interface = {
	addBlock = addBlock
}

local function load_level(index)
	local level = levels[index]
	current.leave()
	current = require ('levels/'..level)
	current.enter(level_interface)
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
	for _, block in ipairs(blocks) do
		g.rectangle('fill', block.x, block.y, 50, 20)
	end
end

function level.draw()
	draw_blocks()
end

return level
