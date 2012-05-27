function love.load()
	require 'lib.math'
	Gamestate = require 'lib.hump.gamestate'
	Timer = require 'lib.hump.timer'
	Vector = require 'lib.hump.vector'
	Signals = require 'lib.hump.signal'
	GUI = require 'lib.quickie'
	EntityList = require 'lib.entity_list'

	show_debug = false

	g = love.graphics
	love.physics.setMeter(30)

	Font = {}
	Font.title = g.newFont('media/fonts/Jura-DemiBold.ttf', 70)
	Font.big = g.newFont('media/fonts/Jura-DemiBold.ttf', 50)
	Font.gui = g.newFont('media/fonts/Jura-DemiBold.ttf', 20)
	Font.normal = g.newFont('media/fonts/Jura-DemiBold.ttf', 15)

	state = {}
	state.main_menu = require 'states.main_menu'
	state.play = require 'states.play'
	state.play_help = require 'states.play_help'
	state.play_menu = require 'states.play_menu'

	require 'game'

	Gamestate.switch(state.main_menu)
end

function love.update(dt)
	Timer.update(dt)
	Gamestate.update(dt)
end

function love.draw()
	Gamestate.draw()
	GUI.core.draw()

--DEBUG
	if show_debug then
		local debug_text = ''
		debug_text = debug_text .. love.timer.getFPS()..' fps';
		debug_text = debug_text .. '\n' .. game.world:getBodyCount() .. ' bodies'
		debug_text = debug_text .. '\n' .. game.level.blocks:count() .. ' blocks'
		debug_text = debug_text .. '\n' .. game.player.balls:count() .. ' balls'
		g.setColor(255,255,255)
		g.setFont(Font.normal)
		g.print(debug_text, 5, 5)
	end
end

function love.keypressed(key, code)
	if key == 'f12' then g.toggleFullscreen() end
	Gamestate.keypressed(key, code)
	GUI.keyboard.pressed(key, code)

--DEBUG
	if key == 'f2' then show_debug = not show_debug end
end

function love.mousepressed(x, y, button)
	Gamestate.mousepressed(x, y, button)
end
