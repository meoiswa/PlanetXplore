--[[

	Author: Meoiswa Twang
	File: player.lua
	Description: Defines the player object.

	--- History ---
	Version	Changes
	1		Created
	2       Removed force lines, changed velocity tracker to an "pre"-image
			Changed thrust to be a property, added camera property
	--- End ---

]]--

Player = class("Player")

function Player:initialize( x, y, mass, inertia)
	self.physics = {}
	self.physics.body = love.physics.newBody( world, x, y, mass, inertia)
	self.physics.shape = love.physics.newRectangleShape(self.physics.body, 0,0, 100,65)
	self.physics.shape:setData(self)
	--self.physics.shape = love.physics.newPolygonShape(self.physics.body, 30,0, -25,20, -25,-20)
	
	self.angVelLimit=1
	self.thrust = 260
	self.physics.force = {}
	self.cam = Camera(self)
end

function Player:type( )
	return "player"
end

function Player:getCam()
	return self.cam
end

function Player:draw()
	local r,g,b,a = love.graphics.getColor()

	love.graphics.setColor(255,255,255,255)
	local physbody = self.physics.body
	local x,y = physbody:getPosition()
	local angle = physbody:getAngle()
	local lx = math.cos(angle)*100/self.cam:getZoom()
	local ly = math.sin(angle)*100/self.cam:getZoom()
	local vx,vy = physbody:getLinearVelocity()

	love.graphics.setColor(255,255,255,255)
	love.graphics.polygon("fill", self.physics.shape:getPoints())
	--love.graphics.circle("fill", x+80*math.cos(angle),y+80*math.sin(angle), 40, 100)
	--love.graphics.circle("fill", x-80*math.cos(angle),y-80*math.sin(angle), 40, 100)

	love.graphics.setColor(0,255,255,255)
	love.graphics.line(x,y,x+vx/self.cam:getZoom(),y+vy/self.cam:getZoom())



	love.graphics.setColor(255,255,0,255)

	love.graphics.line(x,y,x+lx,y+ly)





	love.graphics.setColor( r, g, b, a )
end

function Player:applyThrust( force )
	local physbody = self.physics.body
	local angle = physbody:getAngle()
	local fx = math.cos(angle)*force
	local fy = math.sin(angle)*force
	physbody:applyForce(fx,fy)
end

function Player:applyTorque ( torque )
	local physbody = self.physics.body
	local angVel = physbody:getAngularVelocity()
	if (torque > 0 and angVel < self.angVelLimit) or (torque < 0 and angVel > -self.angVelLimit) then
		physbody:applyTorque(torque)
	end

end

function Player:update(dt)

	if love.keyboard.isDown( "up" ) then
		self:applyThrust(self.thrust)
	end
	if love.keyboard.isDown( "down" ) then
		self:applyThrust(-self.thrust/2)
	end
	if love.keyboard.isDown( "left" ) then
		self:applyTorque(-1)
	end
	if love.keyboard.isDown( "right" ) then
		self:applyTorque(1)
	end
	if love.keyboard.isDown("w") then
		self.cam:setZoom(self.cam:getZoom()+0.01)
	end
	if love.keyboard.isDown("s") then
		self.cam:setZoom(self.cam:getZoom()-0.01)
	end
end

function Player:camDraw(  )
	self.cam:draw()
end

function Player:camUpdate( dt )
	self.cam:update()
end
