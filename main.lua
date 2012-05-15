function love.load()
	dofile 'lib/math.lua'
	gs = require 'lib.hump.gamestate'
	Timer = require 'lib.hump.timer'
	vector = require 'lib.hump.vector'
	gui = require 'lib.quickie'

	show_debug = false

	g = love.graphics
	love.physics.setMeter(30)

	Font = {}
	Font.big = g.newFont(50)
	Font.gui = g.newFont(20)
	Font.normal = g.newFont(13)

	Ball = require 'game.ball'
	Block = require 'game.block'
	Paddle = require 'game.paddle'

	game = {}
	game.world = love.physics.newWorld(0, 0)
	game.level = require 'game.level'

	game.state = {}
	game.state.menu = require 'states.main_menu'
	game.state.play = require 'states.play'

	gs.switch(game.state.menu)
end

function love.update(dt)
	Timer.update(dt)
	gs.update(dt)
end

function love.draw()
	gs.draw()
	g.setFont(Font.gui)
	gui.core.draw()

--DEBUG
	if show_debug then
		local debug_text = ''
		debug_text = debug_text .. love.timer.getFPS()..' fps';
		debug_text = debug_text .. '\n' .. game.world:getBodyCount() .. ' bodies'
		debug_text = debug_text .. '\n' .. #game.level.blocks .. ' blocks'
		g.setColor(255,255,255)
		g.setFont(Font.normal)
		g.print(debug_text, 5, 5)
	end
end

function love.keypressed(key, code)
	if key == 'f12' then g.toggleFullscreen() end
	gs.keypressed(key, code)
	gui.core.keyboard.pressed(key, code)

--DEBUG
	if key == 'f2' then show_debug = not show_debug end
	if key == 'f5' then game.level.next() end
	if key == 'kp+' then paddle:setWidth(paddle:getWidth() + 20) end
	if key == 'kp-' then paddle:setWidth(paddle:getWidth() - 20) end
end

function love.mousepressed(x, y, button)

--DEBUG
	if button == 'wu' then
		paddle:setShapeAngle( paddle:getShapeAngle() + math.pi/10 )
	end
	if button == 'wd' then
		paddle:setShapeAngle( paddle:getShapeAngle() - math.pi/10 )
	end
end