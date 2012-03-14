--[[

	Author: Meoiswa
	File: main.lua
	Description: PlanetXplore
	Fly into planets!
	--- History ---
	Version	Changes
	1		Created
	2       Added Camera, Gravitaster, Misc. Changes
	--- End ---

]]--

world = love.physics.newWorld( -100000,-100000, 100000,100000)
--This should be more than enough space!
planets = {}
--Holds the static planets where the player can go in and explore
physobjs = {}
--Holds the objects affected by gravity
gravis = {}
--Holds the Gravitasters

require("MiddleClass");
require("AdditionalMath");
require("planet");
require("player");
require("camera");
require("gravitaster");


function love.load()
	--This function is called exactly once at the beginning of the game.
	planet1 = Planet(0,0,3000,10000000)

	planet2 = Planet(0,-10000,1200,600000)
	table.insert(planets,planet1)
	table.insert(planets,planet2)
	ply = Player(0,-3100,100,1)
	ply.physics.body:setAngle(math.rad(-90))
	table.insert(physobjs,ply)
	gravitaster = Gravitaster( ply, planet1 )
	gravitaster2 = Gravitaster( ply, planet2 )
	table.insert(gravis,gravitaster)
	table.insert(gravis,gravitaster2)
	love.graphics.setFont()
end

function love.update(dt)
	--Triggered every game frame. Used to update the state of the game
	world:update(dt)
	for k,v in pairs(planets) do
		for q,j in pairs(physobjs) do
			v:Pull(j)
		end
	end
	ply:update(dt)
	ply:camUpdate(dt)
	for k,v in pairs(gravis) do
		v:update(dt)
	end 
end

function love.draw()
	
	ply:camDraw()
	--Triggered every graphics frame. Used to draw on the screen.
	for k,v in pairs(planets) do
		v:draw()
	end

	for k,v in pairs(physobjs) do
		v:draw()
	end
	
	for k,v in pairs(gravis) do
		v:draw()
	end

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