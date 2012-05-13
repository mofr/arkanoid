local LevelWin = {}
LevelWin.__index = LevelWin
LevelWin.__call = function(self) return self.win end

local function new()
	local win = {}
	win.win = false

	return setmetatable(win, LevelWin)
end

function LevelWin:reset()
	self.win = false
end

function LevelWin:update(dt)
	if not self.win then
		if #game.level.blocks == 0 and not game.level.death() then
			self.win = true

			game.level.timer:add(3, function()
				self.win = false
				game.level.next()
			end)
		end
	end
end

function LevelWin:draw()
	if self.win then
		g.setColor(255, 255, 255)
		g.setFont(Font.big)
		local text = 'Level complete!'
		local f = g.getFont()
		g.print(text, (g.getWidth()-f:getWidth(text))/2, (g.getHeight()-f:getHeight(text))/2)
	end
end

return setmetatable({new=new}, {__call = function(_, ...) return new(...) end})
