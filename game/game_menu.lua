local menu = {}

local __NULL__ = function() end
menu.resume = __NULL__
menu.exit = __NULL__

function menu:enter()
	love.mouse.setVisible(true)
	love.mouse.setGrab(false)
end

function menu:leave()
end

local bw = 120
local bh = 40
local spacing = 10

function menu:update(dt)
	local w = g.getWidth()
	local h = g.getHeight()
	local top = h/3

	if gui.Button('Resume game', w/2-bw/2,top, bw,bh) then
		menu.resume()
	end
	
	top = top + bh + spacing
	if gui.Button('Exit to main menu', w/2-bw/2,top, bw,bh) then
		menu.exit()
	end
end

function menu:keypressed(key)
	if key == 'escape' then menu.resume() end
end

return menu
