local help = Gamestate.new()
local title = 'Help'
local tips = {
	{'Positive paddle pole', 'Left mouse button'},
	{'Negative paddle pole', 'Right mouse button'},
	{'Increase/decrease paddle angle', 'Scroll up/down'},
	{'Increase/decrease paddle size', '+/-'},
	{'Next level', 'F5'},
	{'Toggle fullscreen', 'F12'},
	{'Show this help', 'F1'}
}

local mouseX, mouseY

function help:enter()
	mouseX, mouseY = love.mouse.getPosition()
end

function help:leave()
	love.mouse.setPosition( mouseX, mouseY )
end

function help:keypressed(key, code)
	if key == 'f1' or key == 'escape' then Gamestate.switch(state.play) end
end

function help:update(dt)
	local f = Font.gui
	g.setFont(f)
	g.setColor(255,255,255)
	
	local spacing = 20
	local y = 0
	local leftSize = {g.getWidth()/2-spacing, g.getHeight()/2}
	local rightSize = {g.getWidth()/2, g.getHeight()/2}
	local leftPos = 0
	local rightPos = g.getWidth()/2+spacing
	for _,tip in ipairs(tips) do
		GUI.Label{text=tip[1], align='right', pos={leftPos, y}, size=leftSize }
		GUI.Label{text=tip[2], align='left', pos={rightPos, y}, size=rightSize }
		y = y + f:getHeight()
	end
end

function help:draw()
	game.draw()
	g.setColor(0, 0, 0, 210)
	g.rectangle('fill', 0, 0, g.getWidth(), g.getHeight())

	local f = Font.big
	g.setFont(f)
	g.setColor(255,255,255)
	g.print(title, (g.getWidth()-f:getWidth(title))/2, g.getHeight()/6)
end

return help
