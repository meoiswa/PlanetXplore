--[[

	Author: Meoiswa Twang
	File: world.lua
	Description: Defines the planet class

	--- History ---
	Version	Changes
	1		Created as world.lua
	2		Changed name from world.lua to planet.lua
	3		Planets now scale and render images
	4       Added EventHorizon function
	--- End ---

]]--

Planet = class("Planet")
function Planet:initialize( x, y, radius, mass )
	self.physics = {}
	self.physics.body = love.physics.newBody(world, x, y, 0, 0 )
	self.mass = mass
	self.radius = radius
	self.physics.shape = love.physics.newCircleShape( self.physics.body, 0,0, radius)
	self.image = love.graphics.newImage("planet_glow.jpg")
	self.halfW = self.image:getWidth()/2
	self.halfH = self.image:getHeight()/2
	self.scaleX = self.radius/(self.halfW)
	self.scaleY = self.radius/(self.halfH)
end

function Planet:draw()
	local x,y = self.physics.body:getPosition()
	love.graphics.draw(self.image, x,y, 0, self.scaleX,self.scaleY, self.halfW,self.halfH)
	--Surface Line:
	love.graphics.circle("line", x,y, self.radius, 100)
end

function Planet:getPull( object )
	local fx,fy = gravity(self, object)
	return fx,fy
end

function Planet:Pull( object )
	local fx,fy = self:getPull(object)
	object.physics.body:applyForce(fx,fy)
end

--Gets the event horizon of an object with certain thrust
--(The distance from where the object will no longer
-- be able to push itself away from the planet)
function Planet:EventHorizon( a )
    local amass = a.mass or a.physics.body:getMass()
    local dist = ((amass*self.mass)/a.thrust)^(1/2)
    return dist
end