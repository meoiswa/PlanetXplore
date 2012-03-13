--[[

	Author: Meoiswa Twang
	File: world.lua
	Description: Defines the planet class

	--- History ---
	Version	Changes
	1		Created as world.lua
	2		Changed name from world.lua to planet.lua
	--- End ---

]]--

Planet = class("Planet")
function Planet:initialize( x, y, radius, mass )
	self.physics = {}
	self.physics.body = love.physics.newBody(world, x, y, 0, 0 )
	self.mass = mass
	self.radius = radius
	self.physics.shape = love.physics.newCircleShape( self.physics.body, 0,0, radius)

end

function Planet:draw()
	local x,y = self.physics.body:getPosition()
	love.graphics.circle("fill", x,y, self.radius, 100)
end

function Planet:Pull( object )
	local fx,fy = gravity(self, object)
	object.physics.body:applyForce(fx,fy)
end

