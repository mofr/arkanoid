local menu = gs.new()

function menu:init()
end

function menu:enter()
	love.mouse.setVisible(true)
	love.mouse.setGrab(false)
end

local size = {200, 40}

function menu:update(dt)
	local w = g.getWidth()
	local h = g.getHeight()

	local pos = {(w-size[1])/2, h/3}
	gui.group.push{grow='down', spacing=8, size=size, pos=pos}

	if gui.Button{text='Start game'} then
		game.start()
	end

	if gui.Button{text='Начать игру'} then
		game.start()
	end

	if gui.Button{text='Exit'} then
		love.event.push('quit')
	end

	gui.group.pop()
end

function menu:draw()
end

function menu:keypressed(key)
	if key == 'escape' then love.event.push('quit') end
end

return menu
