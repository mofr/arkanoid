local menu = Gamestate.new()

function menu:init()
end

function menu:enter()
	love.mouse.setVisible(true)
	love.mouse.setGrab(false)
end

local size = {200, 45}

function menu:update(dt)
	local w = g.getWidth()
	local h = g.getHeight()

	g.setFont(Font.gui)

	local pos = {(w-size[1])/2, h/3}
	GUI.group.push{grow='down', spacing=8, size=size, pos=pos}

	if GUI.Button{text='Start game'} then
		game.start()
		Gamestate.switch(state.play)
	end

	if GUI.Button{text='Начать игру'} then
		game.start()
		Gamestate.switch(state.play)
	end

	if GUI.Button{text='Exit'} then
		love.event.push('quit')
	end

	GUI.group.pop()
end

function menu:draw()

	--title
	local title = 'Arkanoid'
	local f = Font.title
	g.setFont(f)
	g.setColor(255,255,255)
	g.print(title, g.getWidth()/2-f:getWidth(title)/2, g.getHeight()/6-f:getHeight(title)/2)
end

function menu:keypressed(key)
	if key == 'escape' then love.event.push('quit') end
end

return menu
