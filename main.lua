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
	Font.big = g.newFont('media/fonts/Jura-DemiBold.ttf', 50)
	Font.gui = g.newFont('media/fonts/Jura-DemiBold.ttf', 20)
	Font.normal = g.newFont('media/fonts/Jura-DemiBold.ttf', 13)

	require 'game.core'

	state = {}
	state.main_menu = require 'states.main_menu'
	state.play = require 'states.play'
	state.play_menu = require 'states.play_menu'

	gs.switch(state.main_menu)
end

function love.update(dt)
	Timer.update(dt)
	gs.update(dt)
end

function love.draw()
	gs.draw()
	g.setFont(Font.gui) --temporary, set in styles
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
end

function love.mousepressed(x, y, button)
	gs.mousepressed(x, y, button)
end
