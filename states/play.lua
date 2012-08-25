local main = Gamestate.new()

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
	if key == 'b' then game.player.balls:new{x=game.player.paddle.x, y=game.player.paddle.y-30, pole=1} end
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
