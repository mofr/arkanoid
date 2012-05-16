game = {}

game.timer = Timer()
game.world = love.physics.newWorld(0, 0)
game.level = require 'game.level'
game.player = require 'game.player'
game.hud = require 'game.hud'
require 'game.collisions'

function game.start()
	game.timer:clear()
	game.player.reset()
	game.level.first()
	gs.switch(state.play)
end

function game.update(dt)
	game.world:update(dt)
	game.level.update(dt)
	game.player.update(dt)
	game.hud.update(dt)
	game.timer:update(dt)
end

function game.draw()
	game.level.draw()
	game.player.debugDraw()
	game.hud.draw()
end
