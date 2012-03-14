--[[

	Author: Meoiswa Twang
	File: camera.lua
	Description: Defines a camera instance
	Cameras track a physical body and follow it, rendering
	everything else appropietly

	--- History ---
	Version	Changes
	1		Created	
	--- End ---

]]--

Camera = class("Camera");

function Camera:initialize( object, rotate )
	self.target = object.physics.body
	self.planet = self:getStrongestPlanet()
	self.width = love.graphics.getWidth()
	self.height = love.graphics.getHeight()
end

function Camera:update(dt)
	self.x,self.y = self:getPosition()
	self.ang = self:calculateAngle()

	local ax,ay = self:getPosition()
	local bx,by = self.planet.physics.body:getPosition()
	self.dist = math.dist(ax,ay,bx,by)
	self.surfacedist = self.dist-self.planet.radius
	self.planet = self:getStrongestPlanet()
	self.scaleFactor = (self.height/2)/(self.surfacedist+250)
	if self.scaleFactor > 1 then self.scaleFactor = 1 end
	if self.scaleFactor < 0.3 then self.scaleFactor = 0.3 end
end 

function Camera:draw( func )
	if self.planet then
		--Call function to draw objects not affected by camera
		if func then func() end
		love.graphics.print("Distance to Strongest Gravity Force Source: " .. self.dist, 0,0)
		love.graphics.print("Distance to 'Ground': " .. self.surfacedist , 0,20)

		--Zooming to keep the planet surface in camera
		love.graphics.print("Scale factor: " .. self.scaleFactor .. "x", 0,40)
		love.graphics.scale(self.scaleFactor)

		love.graphics.translate((self.width/self.scaleFactor)/2,(self.height/self.scaleFactor)/2)
		love.graphics.rotate(self.ang)
		love.graphics.translate( -self.x,-self.y )

		love.graphics.setColor(255,255,255,255)
	end
	
end

function Camera:getZoom()
	return self.scaleFactor
end

function Camera:getPosition()
	return self.target:getPosition()
end

function Camera:getX()
	return self.target:getX()
end

function Camera:getY()
	return self.target:getY()
end

function Camera:getAngle()
	return self.target:getAngle()
end

function Camera:getActivePlanet( )
	return self.planet
end

function Camera:getStrongestPlanet()
	local planet,angle = nil,nil
	grav = 0
	for k,v in pairs(planets) do 
		local ax,ay = self:getPosition()
		local bx,by = v.physics.body:getPosition()
		local dist = math.dist(ax,ay,bx,by)
		local newgrav = v.mass/math.pow(dist,2)
		if newgrav > grav then 
			grav = newgrav
			planet = v
		end
	end
	return planet
end

function Camera:calculateAngle()
	local angle = 0
	if self.planet then
		local ax,ay = self:getPosition()
		local bx,by = self.planet.physics.body:getPosition()
		angle = math.angle(ax,ay,bx,by)
	end
	return angle
end 
