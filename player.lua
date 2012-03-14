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
	--self.physics.shape = love.physics.newCircleShape( self.physics.body, 0,0, 25)
	self.physics.shape = love.physics.newPolygonShape(self.physics.body, 30,0, -25,20, -25,-20)
	--love.physics.newRectangleShape(self.physics.body, 0,0, 60,40)
	self.angVelLimit=1
	self.thrust = 260
	self.physics.force = {}
	self.cam = Camera(self)
end

function Player:getCam()
	return self.cam
end

function Player:draw()
	local r,g,b,a = love.graphics.getColor()

	love.graphics.setColor(255,255,255,255)
	local physbody = self.physics.body
	local x,y = physbody:getPosition()
	--love.graphics.circle("fill", x,y, 25, 100)
	love.graphics.polygon("fill", self.physics.shape:getPoints())



	love.graphics.setColor(255,255,0,255)
	local angle = physbody:getAngle()
	local lx = math.cos(angle)*100
	local ly = math.sin(angle)*100
	love.graphics.line(x,y,x+lx,y+ly)

	love.graphics.setColor(0,255,0,255)
	local vx,vy = physbody:getLinearVelocity()
	love.graphics.line(x,y,x+vx,y+vy)
	love.graphics.translate(vx,vy)
	love.graphics.polygon("line", self.physics.shape:getPoints())
	love.graphics.translate(-vx,-vy)

	--[[
	for k,v in pairs(self.physics.force) do
		love.graphics.line(x,y,x+v[1],y+v[2])
		table.remove(self.physics.force,k)
	end
	]]--

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
end

function Player:camDraw(  )
	self.cam:draw()
end

function Player:camUpdate( dt )
	self.cam:update()
end