
function love.load()
	gs = require 'hump/gamestate'
	g = love.graphics

	game = {}
	game.menu = require 'states/menu'
	game.main = require 'states/main'
	gs.switch(game.menu)
end

function love.update(dt)
	gs.update(dt)
end

function love.draw()
	gs.draw()

	g.setColor(255,255,255)
	g.print(love.timer.getFPS()..' fps', 5, 5)
end

function love.keypressed(key)
	gs.keypressed(key)
end
