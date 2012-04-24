-- start, play, pause, win, death
--state = "start"

function love.load()
	g = love.graphics

	love.mouse.setVisible(false)
	gravity = true
	grid_visible = false

	particle = g.newImage('flare.png')
	part1 = g.newImage("part1.png");
	explosions = {}

	game = require 'game'
	game.level = require 'level'
	game.level.load()
end

function love.update(dt)
	if love.mouse.isDown('l') then
		game.level.board.pole = -1
	elseif love.mouse.isDown('r') then
		game.level.board.pole = 1
	else
		game.level.board.pole = 0
	end
	game.update(dt)
--	ps:setPosition(love.mouse.getX(), love.mouse.getY())
--	ps:update(dt)

	for i, e in ipairs(explosions) do 
		if not e:isActive() then
			table.remove(explosions, i)
		else
			e:update(dt) 
		end
	end
end

function love.draw()
	game.draw()

	love.graphics.setColorMode("modulate")
	love.graphics.setBlendMode("additive")
--	g.draw(ps, 0, 0)

	for _, e in ipairs(explosions) do g.draw(e, 0, 0) end

	g.setColor(255,255,255)
	local particles = 0
	for _, e in ipairs(explosions) do particles = particles + e:count() end
	for _, b in ipairs(game.level.balls) do if b.ps then particles = particles + b.ps:count() end end
	local text = particles..' particles'
	text = text..'\n'..love.timer.getFPS()..' fps'
	text = text..'\n'..#explosions..' explosions'
	g.print(text, 5, 5)
end

function love.keypressed(key)
	game.keypressed(key)
	if key == "escape" then love.event.push('quit') end
	if key == "g" then gravity = not gravity end
	if key == "t" then grid_visible = not grid_visible end
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(button)
end
