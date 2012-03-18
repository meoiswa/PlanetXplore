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
	5       Collisions are handled manually
	--- End ---

]]--

Planet = class("Planet")
function Planet:initialize( x, y, radius, mass )
	self.physics = {}
	self.physics.body = love.physics.newBody(world, x, y, 0, 0 )
	self.mass = mass
	self.radius = radius
	self.atmos = {}
	self.atmos.psi = 1
	self.atmos.radius = self.radius + 2000
	--self.physics.shape = love.physics.newRectangleShape(self.physics.body, 0,0, 10000,10000)
	--self.physics.shape = love.physics.newCircleShape( self.physics.body, 0,0, radius)
	--self.physics.shape:setData(self)
	self.image = love.graphics.newImage("planet_glow.jpg")
	self.halfW = self.image:getWidth()/2
	self.halfH = self.image:getHeight()/2
	self.scaleX = self.radius/(self.halfW)
	self.scaleY = self.radius/(self.halfH)
	self.count = {}
end

function Planet:type( )
	return "planet"
end


function Planet:draw()
	local x,y = self.physics.body:getPosition()
	local ax,ay = ply.physics.body:getPosition()
	local dist = math.dist(ax,ay,x,y)
	--local bright = 
	--self.bright = 
	--love.graphics.circle("fill", x,y, self.atmosphere, 100)

	--love.graphics.draw(self.image, x,y, 0, self.scaleX,self.scaleY, self.halfW,self.halfH)
	--Surface Line:
	love.graphics.setColor(255,255,255,255)
	love.graphics.circle("line", x,y, self.radius, 100)
	--love.graphics.polygon("line", self.physics.shape:getPoints())
	love.graphics.line(x,y,x+self.radius,y)
	love.graphics.line(x,y,x-self.radius,y)
	love.graphics.line(x,y,x,y+self.radius)
	love.graphics.line(x,y,x,y-self.radius)

	--[[local lx,ly = self:getLift(ply)
	print(lx,ly)
	love.graphics.line(ax,ay,ax+lx,ay+ly)]]
end

function Planet:getPSI( object )
	local x,y = self.physics.body:getPosition()
	local ax,ay = object.physics.body:getPosition()
	local dist = math.dist(ax,ay,x,y)
	local psi = (self.atmos.psi*(self.atmos.radius-dist))/(self.atmos.radius-self.radius)
	return psi
end

function Planet:getLift( object )
	local ax,ay = object.physics.body:getPosition()
	local vx,vy = object.physics.body:getLinearVelocity()
	local bx,by = self.physics.body:getPosition()
	local angle = math.angle(ax,ay,bx,by)
	local vel = (vx^2 + vy^2)^(1/2)
	local vertivel = vel*math.sin(object.physics.body:getAngle())
end

function Planet:update( dt, objs )
	for q,j in pairs(objs) do
		self:Pull(j)

	end
end

function Planet:getPull( object )
	local fx,fy = gravity(self, object)
	return fx,fy
end

function Planet:distanceToNearestPoint(distance, nx, ny, ax, ay, ... )
	if ax and ay then 
		local bx,by = self.physics.body:getPosition()
		local dist = math.dist(ax,ay,bx,by)
		if dist < distance then
			distance = dist
			nx = ax
			ny = ay
		end
		nx,ny = self:distanceToNearestPoint(distance, nx, ny, unpack(arg))
	end
	return nx,ny
end


function Planet:Pull( object )
	local ax,ay = object.physics.body:getPosition()
	local bx,by = self.physics.body:getPosition()
	local dist = math.dist(ax,ay,bx,by)
	local angle = math.angle(ax,ay,bx,by)
	local fx,fy = self:getPull(object)
	
	--Find if any point of the given object is inside the planet
	local nx,ny = self:distanceToNearestPoint( math.huge, x,y, ply.physics.shape:getPoints() )
	local neardist = math.dist(nx,ny,bx,by)
	if (neardist<=self.radius) then
		--Push it outside
		local nearangle = math.angle(nx,ny,bx,by)
		local pushdist = self.radius - neardist
		local px = pushdist*math.sin(nearangle)
		local py = pushdist*math.cos(nearangle)
		object.physics.body:setX(ax-px)
		object.physics.body:setY(ay-py)

		--TODO: propper bouncyness
		--local vx,vy = object.physics.body:getLinearVelocity()
		--object.physics.body:setLinearVelocity(vx,-vy/3)
	else
		object.physics.body:applyForce(fx,fy)
	end
	
	--elseif dist < self.radius then 
	--	object.physics.body:applyForce(-fx,-fy)
	--end
end

--Gets the event horizon of an object with certain thrust
--(The distance from where the object will no longer
-- be able to push itself away from the planet)
function Planet:EventHorizon( a )
	local constant = gravConstant or 1
	local amass = a.mass or a.physics.body:getMass()
	local dist = constant*((amass*self.mass)/a.thrust)--^(1/2)
	return dist
end

