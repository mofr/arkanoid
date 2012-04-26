local menu = gs.new()

function menu:init()
end

function menu:enter()
	love.mouse.setVisible(true)
end

function menu:draw()
	g.print('Press SPACE to start game', 100, 5)
end

function menu:keypressed(key)
	if key == ' ' then gs.switch(game.main) end
	if key == 'escape' then love.event.push('quit') end
end

return menu
