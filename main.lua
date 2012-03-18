--[[

	Author: Meoiswa
	File: main.lua
	Description: PlanetXplore
	Fly into planets!
	--- History ---
	Version	Changes
	1		Created
	2       Added Camera, Gravitaster, Misc. Changes
	3       Planets no longer have physical shapes
	        Instead, collisions are handled manually
	--- End ---

]]--

gravConstant = 3
world = love.physics.newWorld( -1000000,-1000000, 1000000,1000000)

--This should be more than enough space!
planets = {}
--Holds the static planets where the player can go in and explore
physobjs = {}
--Holds the objects affected by gravity
gravis = {}
--Holds the Gravitasters

require("MiddleClass");
Vector = require("vector");
require("AdditionalMath");
require("planet");
require("player");
require("camera");
require("gravitaster");



function love.load()
	--This function is called exactly once at the beginning of the game.
	--Large planet
	planet1 = Planet(0,12000,10000,5000)
	--Small planet
	planet2 = Planet(0,-30000,2000,1000)
	--Medium planet
	planet3 = Planet(20000,7500,1800,3000)
	table.insert(planets,planet1)
	table.insert(planets,planet2)
	table.insert(planets,planet3)

	ply = Player(0,0,100,1)
	table.insert(physobjs,ply)

	table.insert(gravis,Gravitaster( ply, planet1 ))
	table.insert(gravis,Gravitaster( ply, planet2 ))
	table.insert(gravis,Gravitaster(ply,planet3))
	love.graphics.setFont()
	print(world:getMeter())
end

function love.update(dt)
	--Triggered every game frame. Used to update the state of the game
	
	for k,v in pairs(planets) do
		v:update(dt,physobjs)
	end
	ply:update(dt)
	ply:camUpdate(dt)
	for k,v in pairs(gravis) do
		v:update(dt)
	end 
	world:update(dt)
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
