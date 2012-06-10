local hud = {}

function hud.update(dt)
end

local function player_eff()
	return math.round(game.player.effectiveness*100) .. '%'
end

function hud.draw()
	g.setColor(255,255,255)
	g.setFont(Font.normal)
	g.print('Your score: ' .. game.player.score, 0, game.level.h)
	g.print('Effectiveness: ' .. player_eff(), game.level.w/2, game.level.h)
	g.print('Level: ' .. game.level.name(), 0, 0)
end

return hud
