local function setup()
	game.collider:registerCallback('ball','block', function(ball, block)
		block:damage()
		game.player.score = game.player.score + 10
	end)
	
	game.collider:registerCallback('ball','floor', function(ball, floor)
		ball.dead = true 
	end)
end

return {
	setup = setup
}