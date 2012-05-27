local main = Gamestate.new()

--[[
local particle = g.newImage('media/flare.png')
local part1 = g.newImage('media/part1.png');

function newBallPS()
	p = g.newParticleSystem(particle, 1500)
	p:setPosition(100, 100)
	p:setEmissionRate(350)
	p:setSizes(0.5, 0.3, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
	p:setTangentialAcceleration(-100.0, 100.0)
	p:setSpeed(50, 100)
	p:setParticleLife(1.0)
	p:setSpin(1)
	p:setSpread(360)
	p:setColors(120,130,255,255, 200,200,255,255, 200,200,255,255)
	p:start()
	return p
end
]]

function main:init()
end

function main:enter()
	love.mouse.setVisible(false)
	love.mouse.setGrab(true)
end

function main:leave()
end

function main:keypressed(key)
	if key == 'f1' then Gamestate.switch(state.play_help) end
	if key == 'escape' or key == 'p' then Gamestate.switch(state.play_menu) end

--DEBUG
	if key == 'f5' then game.level.next() end
	if key == 'kp+' then game.player.paddle:setWidth(game.player.paddle:getWidth() + 20) end
	if key == 'kp-' then game.player.paddle:setWidth(game.player.paddle:getWidth() - 20) end
end

function main:mousepressed(x, y, button)

--DEBUG
	if button == 'wu' then
		game.player.paddle:setShapeAngle( game.player.paddle:getShapeAngle() + math.pi/10 )
	end
	if button == 'wd' then
		game.player.paddle:setShapeAngle( game.player.paddle:getShapeAngle() - math.pi/10 )
	end
end

function main:update(dt)
	game.update(dt)
end

function main:draw()
    game.draw()
end

return main
