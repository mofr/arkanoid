
-- [Ice Project 2012, turtlesort.com]

function love.conf(t)
	t.title = "mofr arkanoid"
	t.author = "mofr"
	t.identity = "mofr_arkanoid"
	t.screen.fsaa = 4
	t.screen.width = 16 * 45
	t.screen.height = 16 * 33
	t.screen.vsync = false
	t.modules.joystick = false
	t.modules.physics = false
end