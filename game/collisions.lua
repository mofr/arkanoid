function beginContact(a, b, c)
	local d1 = a:getUserData()
	local d2 = b:getUserData()
end

function endContact(a, b, c)
	local d1 = a:getUserData()
	local d2 = b:getUserData()

	--kill block
	if d1 and d1.block then d1.block.dead = true end
	if d2 and d2.block then d2.block.dead = true end

	--ball + floor
	if d1 and d2 then
		if d1.floor and d2.ball then
			d2.ball.dead = true
		end
		if d1.ball and d2.floor then
			d1.ball.dead = true
		end
	end
end

function preSolve(a, b, c)
end

function postSolve(a, b, c)
end

game.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
