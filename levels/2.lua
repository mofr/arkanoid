local level = game.level.new()

local function block_creator(w, h)
	return function(x, y)
		return game.level.add_block(x, y, w, h)
	end
end

local b = block_creator(50, 20)

function level.enter()
	b(100, 100)
	b(155, 100)
	b(210, 100)
	b(265, 100)
end

return level
