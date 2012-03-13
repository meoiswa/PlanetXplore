--[[

	Author: Meoiswa Twang
	File: player.lua
	Description: Defines the player object.

	--- History ---
	Version	Changes
	1		Created
	--- End ---

]]--

Player = class("Player")

function Player:initialize( x, y, mass, inertia)
	self.physics = {}
	self.physics.body = love.physics.newBody( world, x, y, mass, inertia)
	self.physics.shape = love.physics.newCircleShape( self.physics.body, 0,0, 25)
	self.angVelLimit=1
	self.physics.force = {}
end

function Player:draw()
	local r,g,b,a = love.graphics.getColor()

	love.graphics.setColor(255,255,255,255)
	local physbody = self.physics.body
	local x,y = physbody:getPosition()
	love.graphics.circle("fill", x,y, 25, 100)

	love.graphics.setColor(255,255,0,255)
	local angle = physbody:getAngle()
	local lx = math.cos(angle)*100
	local ly = math.sin(angle)*100
	love.graphics.line(x,y,x+lx,y+ly)

	love.graphics.setColor(0,255,0,255)
	local vx,vy = physbody:getLinearVelocity()
	love.graphics.line(x,y,x+vx,y+vy)

	love.graphics.setColor(255,0,0,255)
	for k,v in pairs(self.physics.force) do
		love.graphics.line(x,y,x+v[1],y+v[2])
		table.remove(self.physics.force,k)
	end

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
		self:applyThrust(100)
	end
	if love.keyboard.isDown( "down" ) then
		self:applyThrust(-50)
	end
	if love.keyboard.isDown( "left" ) then
		self:applyTorque(-1)
	end
	if love.keyboard.isDown( "right" ) then
		self:applyTorque(1)
	end
end