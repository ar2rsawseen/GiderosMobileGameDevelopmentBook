TouchBall = Core.class(Sprite)

function TouchBall:init(level, x, y)
	self.level = level
	self:setPosition(x,y)
	
	local frames = {}
	for i = 0, 18 do
		local bitmap = Bitmap.new(self.level.g:getTextureRegion("touch"..i..".png"))
		bitmap:setAnchorPoint(0.5, 0.5)
		frames[i] = bitmap
	end
	--create bitmap object from ball graphic
	self.bitmap = MovieClip.new{
		{1, 10, frames[0]}, 
		{11, 15, frames[1]}, 
		{16, 20, frames[2]}, 
		{21, 30, frames[3]}, 
		{31, 40, frames[4]}, 
		{41, 45, frames[5]},
		{46, 50, frames[4]},
		{51, 55, frames[6]},
		{56, 60, frames[4]},
		{61, 65, frames[5]},
		{66, 70, frames[4]},
		{71, 75, frames[6]},
		{76, 80, frames[4]},
		{81, 85, frames[5]},
		{86, 90, frames[4]},
		{91, 95, frames[6]},
		{96, 100, frames[3]},
		{101, 110, frames[2]},
		{111, 115, frames[1]}, 
		{116, 200, frames[0]},
		{201, 205, frames[7]},
		{206, 210, frames[8]},
		{211, 215, frames[9]},
		{216, 220, frames[10]},
		{221, 225, frames[11]},
		{226, 230, frames[12]},
		{231, 235, frames[13]},
		{236, 240, frames[14]},
		{241, 245, frames[15]},
		{246, 250, frames[16]},
		{251, 255, frames[17]},
		{256, 260, frames[18]}
	}
	self.bitmap:setGotoAction(200, 1)
	self.bitmap:setGotoAction(260, 201)
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

function TouchBall:hit()
	self.bitmap:gotoAndPlay(201)
end