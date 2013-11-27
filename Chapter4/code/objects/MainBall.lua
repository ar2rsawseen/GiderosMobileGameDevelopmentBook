MainBall = Core.class(Sprite)

function MainBall:init(level, x, y)
	self.level = level
	self:setPosition(x,y)
	
	--create bitmap object from ball graphic
	self.bitmap = Bitmap.new(self.level.g:getTextureRegion("main1.png"))
	--reference center of the ball for positioning
	self.bitmap:setAnchorPoint(0.5,0.5)
	self:addChild(self.bitmap)
	
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function MainBall:createBody()
	--get radius
	local radius = (self.bitmap:getWidth()/2)*0.85
	
	--create box2d physical object
	local body = self.level.world:createBody{type = b2.DYNAMIC_BODY}
	
	--copy all state of object
	body:setPosition(self:getPosition())
	body:setAngle(math.rad(self:getRotation()))

	local circle = b2.CircleShape.new(0, 0, radius)
	
	local fixture = body:createFixture{shape = circle, density = 1, 
	friction = 0.1, restitution = 0.5}
	
	body.type = "main"
	self.body = body
	body.object = self
	
	table.insert(self.level.bodies, body)
end

function MainBall:onMouseDown(e)
	e:stopPropagation()
	self.startX = self:getX()
	self.startY = self:getY()
	self.isDragged  = true
end

function MainBall:onMouseMove(e)
	if self.isDragged  then
		e:stopPropagation()
		local r = 120
		local xVect = (e.x-self.startX)
		local yVect = (e.y-self.startY)
		local length = math.sqrt(xVect*xVect + yVect*yVect)
			
		if length <= r then
			self:setPosition(e.x, e.y)
		else
			local koef = math.sqrt((r*r)/(xVect*xVect+yVect*yVect))
			self:setX(self.startX+xVect*koef)
			self:setY(self.startY+yVect*koef)
		end
	end
end
	
function MainBall:onMouseUp(e)
	if self.isDragged  then
		e:stopPropagation()
		self.isDragged  = false
		self:createBody()
		--define strength of slingshot
		local strength = 10
		--calculate force vector based on strength 
		--and distance of pull
		local xVect = (self.startX - self:getX())*strength
		local yVect = (self.startY - self:getY())*strength
		--applye impulse to target
		self.body:applyLinearImpulse(xVect, yVect, self:getX(), self:getY())
		
		self:removeEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
		self:removeEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
		self:removeEventListener(Event.MOUSE_UP, self.onMouseUp, self)
		
	end
end

function MainBall:smile()
	local smileTexture = self.level.g:getTextureRegion("main2.png")
	self.bitmap:setTextureRegion(smileTexture)
	Timer.delayedCall(2000, function()
		local normal = self.level.g:getTextureRegion("main1.png")
		self.bitmap:setTextureRegion(normal)
	end)
end

function MainBall:onEnterFrame()
	if self.level.magnetStarted then
		local xForce = 1
		local yForce = 0.6
		if self.level.magnetY < self:getY() then
			yForce = -yForce
		end
		if self.level.magnetX < self:getX() then
			xForce = -xForce
		end
		self.body:applyLinearImpulse(xForce, yForce, self:getX(), self:getY())
	end
end