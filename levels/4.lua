local level = game.level.new()

local Dummy = require 'blocks.dummy'

function level.enter()
	local function dummy(rect)
		game.level.blocks:add( Dummy(rect) )
	end

	LevelGrid {
		cellSize = {80, 50},
		spacing = 3,
		d = dummy,
		[[
			.
			.
			.
			dddd..dddd
			.
			.
			dddd..dddd
		]]
	}
end

return level
