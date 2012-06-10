local Death = {}
Death.__index = Death
Death.__call = function(self) return self.dead end

local function new()
	local death = {}
	death.dead = false

	return setmetatable(death, Death)
end

function Death:reset()
	self.dead = false
end

function Death:update(dt)
	if not self.dead then
		self.dead = game.player.balls:count() == 0 and not game.level.win()

		if self.dead then
			game.level.timer:add(3, function()
				self.dead = false
				game.player.respawn()
			end)
		end
	end
end

function Death:draw()
	if self.dead then
		g.setColor(180, 20, 20)
		g.setFont(Font.big)
		local text = 'All balls are dead!'
		local f = g.getFont()
		g.print(text, (game.level.w-f:getWidth(text))/2, (game.level.h-f:getHeight(text))/2)
	end
end

return setmetatable({new=new}, {__call = function(_, ...) return new(...) end})
