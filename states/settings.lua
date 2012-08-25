local settings = Gamestate.new()
local pre_state
local fullscreen

function settings:enter(pre)
	pre_state = pre
	love.mouse.setVisible(true)
	love.mouse.setGrab(false)
	_, _, fullscreen, _, _ = love.graphics.getMode()
end

local size = {250, 45}

function settings:update(dt)
	local w = g.getWidth()
	local h = g.getHeight()

	g.setFont(Font.gui)

	local pos = {(w-size[1])/2, h/3}
	GUI.group.push{grow='down', spacing=8, size=size, pos=pos}

	local fullscreen_text
	if fullscreen then
		fullscreen_text = 'Switch to window'
	else
		fullscreen_text = 'Switch to full screen'
	end
	if GUI.Button{text=fullscreen_text} then
		love.graphics.toggleFullscreen()
		fullscreen = not fullscreen
	end

	if GUI.Button{text='Ok'} then
		Gamestate.switch(pre_state)
	end

	GUI.group.pop()
end

function settings:draw()
	--title
	local title = 'Settings'
	local f = Font.title
	g.setFont(f)
	g.setColor(255,255,255)
	g.print(title, g.getWidth()/2-f:getWidth(title)/2, g.getHeight()/6-f:getHeight(title)/2)
end

function settings:keypressed(key)
	if key == 'escape' then Gamestate.switch(pre_state) end
end

return settings