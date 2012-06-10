local level = game.level.new()

local White = require 'blocks.white'

function level.enter()
	local function dummy(rect)
		game.level.blocks:add( White(rect) )
	end

	LevelGrid {
		cellSize = White.size,
		spacing = 0,
		d = dummy,
		[[
			.
			.
			.
			.
			d........d
			d........d
			d..d..d..d
			d..d..d..d
			dddddddddd
			dddddddddd
		]]
	}
end

return level
