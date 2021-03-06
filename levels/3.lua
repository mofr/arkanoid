local level = game.level.new()

local Dummy = require 'blocks.dummy'

function level.enter()
	local function dummy(rect)
		game.level.blocks:add( Dummy(rect) )
	end

	LevelGrid {
		cellSize = {60, 40},
		spacing = 1,
		d = dummy,
		[[
			.
			.
			.
			.
			.dddddd..dddddd.
			.d....d..d....d
			.d....d..d....d
			.d....d..d....d
			.d....d..d....d
			.d....d..d....d
			.dddddd..dddddd
		]]
	}
end

return level
