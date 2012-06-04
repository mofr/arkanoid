game = {}

game.timer = Timer()
game.world = love.physics.newWorld(0, 0)
game.level = require 'game.level'
game.player = require 'game.player'
game.hud = require 'game.hud'
game.collider = require 'game.collider'

function game.start()
	game.collider:reset()
	game.timer:clear()
	game.level.first()

	game.player.reset()
	game.player.respawn()

	--TODO: move from here
	game.collider:registerCallback('ball','block', function(ball, block)
		block.dead = true
		game.player.score = game.player.score + 10
	end)
	
	game.collider:registerCallback('ball','floor', function(ball, floor) 
		ball.dead = true 
	end)
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
	game.player.draw()
	game.hud.draw()
end
