
function love.load()
	gs = require 'hump/gamestate'
	timer = require 'hump/timer'
	gui = require 'quickie'
	g = love.graphics

	game = {}
	game.state = {}
	game.state.menu = require 'states/main_menu'
	game.state.play = require 'states/play'
	game.level = require 'game/level'
	game.world = love.physics.newWorld(0, 0)
	love.physics.setMeter(30)
	gs.switch(game.state.menu)

--	floor = {}
--	floor.b = love.physics.newBody(game.world, 120, 200, 'static')
--	floor.s = love.physics.newRectangleShape(200, 50)
--	floor.f = love.physics.newFixture(floor.b, floor.s)
--	floor.f:setFriction(0)
--	floor.f:setRestitution(1)

	local w = g.getWidth()
	local h = g.getHeight()

	outline = {}
	outline.b = love.physics.newBody(game.world, 0, 0, 'static')
	outline.s = love.physics.newChainShape(true, 5, 5, w-5, 5, w-5, h-5, 5, h-5)
	outline.f = love.physics.newFixture(outline.b, outline.s)
	outline.f:setFriction(0)
	outline.f:setRestitution(1)
end

function love.update(dt)
	timer.update(dt)
	gs.update(dt)
end

function love.draw()
	gs.draw()
	gui.core.draw()

	g.setColor(255,255,255)
	g.print(love.timer.getFPS()..' fps', 5, 5)
end

function love.keypressed(key, code)
	if key == 'f12' then g.toggleFullscreen() end
	gs.keypressed(key, code)
	gui.core.keyboard.pressed(key, code)

--DEBUG
	if key == 'k' then
		if #game.level.blocks > 0 then
			table.remove(game.level.blocks, #game.level.blocks)
		end
	end
end
