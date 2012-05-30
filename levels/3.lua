local level = game.level.new()

function level.enter()
	local b = BlockBuilder{size={60, 40}, spacing=2, margin={20, 100, 300, 100}}
	b:grid(b:width(), b:height())
end

return level
