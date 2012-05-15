local menu = gs.new()

function menu:init()
end

function menu:enter()
	love.mouse.setVisible(true)
	love.mouse.setGrab(false)
end

local bw = 150
local bh = 40
local spacing = 10

function menu:update(dt)
	local w = g.getWidth()
	local h = g.getHeight()
	local top = h/3

	if gui.Button('Start game', w/2-bw/2,top, bw,bh) then
		game.start()
	end

	top = top + bh + spacing
	if gui.Button('Exit', w/2-bw/2,top, bw,bh) then
		love.event.push('quit')
	end
end

function menu:draw()
end

function menu:keypressed(key)
	if key == 'escape' then love.event.push('quit') end
end

return menu
