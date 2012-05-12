
function love.load()
	dofile 'lib/math.lua'
	gs = require 'lib.hump.gamestate'
	Timer = require 'lib.hump.timer'
	vector = require 'lib.hump.vector'
	gui = require 'lib.quickie'

	g = love.graphics
	love.physics.setMeter(30)

	Font = {}
	Font.big = g.newFont(30)
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
	local debug_text = ''
	debug_text = debug_text .. love.timer.getFPS()..' fps';
	debug_text = debug_text .. '\n' .. game.world:getBodyCount() .. ' bodies'
	debug_text = debug_text .. '\n' .. #game.level.blocks .. ' blocks'
	g.setColor(255,255,255)
	g.setFont(Font.normal)
	g.print(debug_text, 5, 5)
end

function love.keypressed(key, code)
	if key == 'f12' then g.toggleFullscreen() end
	gs.keypressed(key, code)
	gui.core.keyboard.pressed(key, code)

--DEBUG
	if key == 'f5' then game.level.next() end
end
