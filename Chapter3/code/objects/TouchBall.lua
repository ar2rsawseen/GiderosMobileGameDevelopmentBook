TouchBall = Core.class(Sprite)

function TouchBall:init(level, x, y)
	self.level = level
	self:setPosition(x,y)
	
	--create bitmap object from ball graphic
	self.bitmap = Bitmap.new(self.level.g:getTextureRegion("touch4.png"))
	--reference center of the ball for positioning
	self.bitmap:setAnchorPoint(0.5,0.5)
	self:addChild(self.bitmap)
	self:createBody()
end

function TouchBall:createBody()
	--get radius
	local radius = (self.bitmap:getWidth()/2)*0.85
	
	--create box2d physical object
	local body = self.level.world:createBody{type = b2.STATIC_BODY}
	
	--copy all state of object
	body:setPosition(self:getPosition())
	body:setAngle(math.rad(self:getRotation()))

	local circle = b2.CircleShape.new(0, 0, radius)
	
	local fixture = body:createFixture{shape = circle, density = 1, 
	friction = 0.1, restitution = 0.5}
	
	body.type = "touch"
	self.body = body
	body.object = self
	
	table.insert(self.level.bodies, body)
end