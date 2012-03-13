--[[

	Author: Meoiswa
	File: main.lua
	Description: PlanetXplore
	Fly into planets!
	--- History ---
	Version	Changes
	1		Created
	--- End ---

]]--

world = love.physics.newWorld( 0,0, 10000,10000)
--This should be more than enough space!
planets = {}
--Holds the static planets where the player can go in and explore

require("MiddleClass");
require("AdditionalMath");
require("planet");
require("player");


function love.load()
	--This function is called exactly once at the beginning of the game.
	planet1 = Planet(300,300,50,10000)
	ply = Player(100,100,100,1)
end

function love.update(dt)
	--Triggered every game frame. Used to update the state of the game
	world:update(dt)
	planet1:Pull(ply)
	ply:update(dt)
end

function love.draw()
	--Triggered every graphics grame. Used to draw on the screen.
	planet1:draw()
	ply:draw()
end

function love.quit()
	--Triggered when the game is closed.

end

function love.focus(f)
	--Triggered when window receives or loses focus.

end

function love.keypressed( key, unicode )
	--Triggered when a key is pressed.
end

function love.keyreleased( key, unicode )
	--Triggered when a key is released.

end

function love.mousepressed( x, y, button )
	--Callback function triggered when a mouse button is pressed.

end

function love.mousereleased( x, y, button )
	--Callback function triggered when a mouse button is released.

end

function love.joystickpressed( joystick, button )
	--Called when a joystick button is pressed.

end

function love.joystickreleased( joystick, button )
	--Called when a joystick button is released.

end