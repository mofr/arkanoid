game = {}

game.timer = Timer()
game.world = love.physics.newWorld(0, 0)
game.collider = require 'game.collider'

game.level = require 'game.level'
game.player = require 'game.player'
game.hud = require 'game.hud'

local collisions = require 'game.collisions'

function game.start()
	game.collider:reset()
	game.timer:clear()

	game.level.setSize( g.getWidth()-30 )
	game.level.first()

	game.player.reset()
	game.player.respawn()

	collisions.setup()
end

function game.update(dt)
	game.world:update(dt)
	game.level.update(dt)
	game.player.update(dt)
	game.hud.update(dt)
	game.timer:update(dt)
end

function game.draw()
	g.push()
	g.translate( (g.getWidth()-game.level.w)/2, (g.getHeight()-game.level.h)/2 )

	game.level.draw()
	game.player.draw()
	game.hud.draw()

	g.pop()
end
