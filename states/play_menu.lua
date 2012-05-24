local menu = gs.new()

local function resume()
	gs.switch(state.play)
end

function menu:init()
end

function menu:enter()
	love.mouse.setVisible(true)
	love.mouse.setGrab(false)
end

function menu:leave()
end

local size = {250, 45}

function menu:update(dt)
	local w = g.getWidth()
	local h = g.getHeight()

	g.setFont(Font.gui)

	local pos = {(w-size[1])/2, h/3}
	gui.group.push{grow='down', spacing=8, size=size, pos=pos}

	if gui.Button{text='Resume game'} then
		resume()
	end

	if gui.Button{text='Exit to main menu'} then
		gs.switch(state.main_menu)
	end

	gui.group.pop()
end

function menu:draw()
	game.draw()
	g.setColor(0, 0, 0, 210)
	g.rectangle('fill', 0, 0, g.getWidth(), g.getHeight())
end

function menu:keypressed(key)
	if key == 'escape' or key == 'p' then resume() end
end

return menu
