local hud = {}

function hud.update(dt)
end

function hud.draw()
	g.setColor(255,255,255)
	g.setFont(Font.normal)
	g.print('Your score: ' .. game.player.score, game.level.area.left, game.level.area.bottom)
end

return hud
