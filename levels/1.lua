local level = game.level.new()

local function block_creator(w, h)
	return function(x, y)
		return game.level.blocks:new(x, y, w, h)
	end
end

local block_w = 80
local block_h = 40
local space = 5
local b = block_creator(block_w, block_h)

function level.enter()
	local count_x = 7
	local count_y = 7
	local left = game.level.area.w/2-count_x*(block_w+space)/2
	local top = game.level.area.h/5

	for x = 0,count_x-1 do
		for y = 0,count_y-1 do
			b(left+x*(block_w+space), top+y*(block_h+space))
		end
	end
end

return level
