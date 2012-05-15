local menu = gs.new()

local function resume()
	gs.switch(state.play)
end

local function exit()
	gs.switch(state.main_menu)
end

function menu:init()
end

function menu:enter()
	love.mouse.setVisible(true)
	love.mouse.setGrab(false)
end

function menu:leave()
end

local bw = 220
local bh = 40
local spacing = 10

function menu:update(dt)
	local w = g.getWidth()
	local h = g.getHeight()
	local top = h/3

	if gui.Button('Resume game', w/2-bw/2,top, bw,bh) then
		resume()
	end
	
	top = top + bh + spacing
	if gui.Button('Exit to main menu', w/2-bw/2,top, bw,bh) then
		exit()
	end
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
