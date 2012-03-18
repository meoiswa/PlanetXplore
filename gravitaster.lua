--[[

	Author: Meoiswa Twang
	File: gravitaster.lua
	Description: Gravitaster is a HUD device
	designed to avoid "Gravity Induced Disasters"

	--- History ---
	Version	Changes
	1		Created
	2       Enabled the Event Horizon indicators
	--- End ---

]]--

Gravitaster = class("Gravitaster")

function Gravitaster:initialize( player,planet )
	--Creates a Gravitaster for a planet
	self.player = player
	self.planet = planet
	self.color = {}
	self.time=0
	self:update(0)
end

function Gravitaster:update(dt)
	local ax,ay = self.player.physics.body:getPosition()
	local bx,by = self.planet.physics.body:getPosition()
	self.dist = math.dist(ax,ay,bx,by)
	self.angle = math.angle(ax,ay,bx,by)
	self.x = ax + math.sin(self.angle)*200
	self.y = ay + math.cos(self.angle)*200
	self.cx = ax + math.sin(self.angle)*170
	self.cy = ay + math.cos(self.angle)*170
	local surfacedist = self.dist-self.planet.radius
	self.bright = 255-(255/25000)*surfacedist
	if self.bright < 0 then self.bright = 0 end
	local point = Vector.new(ax,ay)
	local center = Vector.new(bx,by)
	local x1,y1, x2,y2 = 0,0,0,0
	local d = point:dist(center) --hypotenuse
	local r = self.planet.radius --adjacent
	local angle = math.acos(r/d) --cos(theta) = adjacent/hypotenuse

	local arm = (point-center):normalized()*self.planet.radius
	self.tx1,self.ty1 = (arm:rotated(angle) + center):unpack()
	self.tx2,self.ty2 = (arm:rotated(-angle) + center):unpack()

end

function Gravitaster:draw()

	local ax,ay = self.player.physics.body:getPosition()
	local bx,by = self.planet.physics.body:getPosition()
	--Event horizon circl
	love.graphics.setColor(255,0,0,self.bright)
	love.graphics.circle("line", bx, by, self.planet:EventHorizon( self.player ), 100)
	--Gravity source indicator
	
	love.graphics.setColor(0,255,0,self.bright)

	--love.graphics.circle("line", self.cx,self.cy, 30,100)
	love.graphics.line( self.x,self.y,bx,by)

	--Tangents! THANKS A LOT TechnoCat!
	love.graphics.line(ax,ay,self.tx1,self.ty1)
	love.graphics.line(ax,ay,self.tx2,self.ty2)


	love.graphics.setColor(255,255,255,255)
end

function Gravitaster:getDistance()
	return self.dist
end
