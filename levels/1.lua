local level = game.level.new()

function level.enter(game)
	game.addBlock(100, 100)
	game.addBlock(160, 100)
	game.addBlock(220, 100)
end

return level
