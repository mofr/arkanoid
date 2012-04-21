local game = {}

function game.update(dt)
	game.level.update(dt)
end

function game.draw()
	game.level.draw()
end

function game.keypressed(key)
	game.level.keypressed(key)
end

return game
