--[[

	Author: Meoiswa Twang
	File: gravitaster.lua
	Description: Gravitaster is a HUD device
	designed to avoid "Gravity Induced Disasters"

	--- History ---
	Version	Changes
	1		Created
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
	self.x,self.y = bx,by
	self.dist = math.dist(ax,ay,bx,by)
	self.angle = math.angle(ax,ay,bx,by)
	local surfacedist = self.dist-self.planet.radius
	if surfacedist > 125 then
		self.time = self.time+(dt/(surfacedist/5000))
		self.bright = 255*math.abs(math.sin(self.time))
	else 
		self.bright = 255
	end
end

function Gravitaster:draw()
	--Event horizon circl
	love.graphics.setColor(255,0,0,175)
	love.graphics.circle("line", self.x, self.y, self.planet:EventHorizon( self.player, 130), 100)
	--Gravity source indicator
	local ax,ay = self.player.physics.body:getPosition()
	local lx = math.sin(self.angle)*200
	local ly = math.cos(self.angle)*200
	local cx = math.sin(self.angle)*170
	local cy = math.cos(self.angle)*170
	love.graphics.setColor(0,255,0,125)

	love.graphics.circle("line", ax+cx,ay+cy, 30,100)
	love.graphics.line( ax+lx,ay+ly,self.x,self.y)

	love.graphics.setColor(0,255,0,self.bright)
	love.graphics.circle("fill", ax+cx,ay+cy, 30,100)

	love.graphics.setColor(255,255,255,255)
end

function Gravitaster:getDistance()
	return self.dist
end