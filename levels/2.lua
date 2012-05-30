local level = game.level.new()

function level.enter()
	local b = BlockBuilder{size={60,40}, spacing=1, margin={0, 0, 300, 0}}

	local w, h = 5, 6

	b:moveTo(1, 4)
	b:rect(w, h)

	b:moveTo(b:width()-w-2, 4)
	b:rect(w, h)
end

return level
