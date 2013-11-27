LevelScene = Core.class(Sprite)

function LevelScene:init()
	
	local bg = Bitmap.new(Texture.new("images/bg.jpg", true))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setPosition(conf.width/2, conf.height/2)
	self:addChild(bg)
	
	self.g = TexturePack.new("texturepacks/levelScene.txt", "texturepacks/levelScene.png", true)
	
	local restart = Bitmap.new(self.g:getTextureRegion("restart.png"))
	local restartButton = Button.new(restart)
	restartButton:setPosition(-conf.dx, conf.dy + conf.height - restartButton:getHeight())
	self:addChild(restartButton)
	restartButton:addEventListener("click", function()
		sceneManager:changeScene("level", conf.transitionTime, conf.transition, conf.easing)
	end)
	
	self:addEventListener(Event.KEY_DOWN, function(event)
		if event.keyCode == KeyCode.BACK then
			self:back()
		end
	end)
	
	--create world instance
	self.world = b2.World.new(0, 9.8, true)
	
	--set up debug drawing
	local debugDraw = b2.DebugDraw.new()
	self.world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	
	local body = self.world:createBody{type = b2.STATIC_BODY}
	body:setPosition(0, 0)
	local chain = b2.ChainShape.new()
	chain:createLoop(
		0,0,
		conf.width, 0,
		conf.width, conf.height,
		0, conf.height
	)
	local fixture = body:createFixture{shape = chain, density = 1.0, 
	friction = 1, restitution = 0.3}
	
	--store all bodies sprites here
	self.bodies = {}
	
	--run world
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	--add collision event listener
	self.world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	self.world:addEventListener(Event.POST_SOLVE, self.onPostSolve, self)
	
	self.curPack = sets:get("curPack")
	self.curLevel = sets:get("curLevel")
	
	self.level = dataSaver.load("levels/"..self.curPack.."-"..self.curLevel)
	self.ballsLeft = 0
	for i, value in ipairs(self.level) do
		if value.type == "main" then
			self.mainBall = MainBall.new(self, value.x, value.y)
			self:addChild(self.mainBall)
		elseif value.type == "touch" then
			local touch = TouchBall.new(self,  value.x, value.y)
			self:addChild(touch)
			self.ballsLeft = self.ballsLeft + 1
		end
	end
	
	--adding menu button after game elements
	--to make it receive the click event first
	local menu = Bitmap.new(self.g:getTextureRegion("menu.png"))
	local menuButton = Button.new(menu)
	menuButton:setPosition(conf.dx + conf.width - menuButton:getWidth(), conf.dy + conf.height - menuButton:getHeight())
	self:addChild(menuButton)
	menuButton:addEventListener("click", function(self)
		self:openMenu()
	end, self)
	
	local highScore = gm:getScore(self.curPack, self.curLevel)
	local highScoreText = TextField.new(conf.fontSmall, "Highscore: "..highScore)
	highScoreText:setTextColor(0xffff00)
	highScoreText:setPosition(10, 25)
	self:addChild(highScoreText)
	
	self.score = 0
	self.scoreText = TextField.new(conf.fontSmall, "Score: 0")
	self.scoreText:setTextColor(0xffff00)
	self.scoreText:setPosition(10, 55)
	self:addChild(self.scoreText)
	
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end

function LevelScene:updateScore(score)
	self.score = self.score + score
	self.scoreText:setText("Score: "..self.score)
end

function LevelScene:completed()
	sounds:play("complete")
	local isNewHighScore = gm:setScore(self.curPack, self.curLevel, self.score)
	
	self.curPack, self.curLevel = gm:getNextLevel(self.curPack, self.curLevel, true)
	--if curPack is nil it means we reached the end of the game
	if self.curPack == nil then
		local dialog = AlertDialog.new("Game Completed", "You have completed the game", "Yay")
		dialog:addEventListener(Event.COMPLETE, function()
			--goto main sceneManager
			sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing)
		end)
		dialog:show()
	else
		-- we will store new pack and level ids in settings
		sets:set("curPack", self.curPack)
		sets:set("curLevel", self.curLevel)
		
		local dialog = AlertDialog.new("Level Completed", "Continue to next Level", "OK")
		dialog:addEventListener(Event.COMPLETE, function()
			sceneManager:changeScene("level", conf.transitionTime, conf.transition, conf.easing)
		end)
		dialog:show()
	end
end

function LevelScene:createMenu()
	local menu = Shape.new()
	menu:setFillStyle(Shape.SOLID, 0x000000, 0.5)
	menu:beginPath()
	menu:moveTo(-conf.dx,-conf.dy)
	menu:lineTo(-conf.dx, conf.height + conf.dy)
	menu:lineTo(conf.width + conf.dx, conf.height + conf.dy)
	menu:lineTo(conf.width + conf.dx, -conf.dy)
	menu:closePath()
	menu:endPath()
	
	--disable input events
	menu:addEventListener(Event.MOUSE_DOWN, function(e) e:stopPropagation() end)
	menu:addEventListener(Event.MOUSE_MOVE, function(e) e:stopPropagation() end)
	menu:addEventListener(Event.MOUSE_UP, function(e) e:stopPropagation() end)
	menu:addEventListener(Event.TOUCHES_BEGIN, function(e) e:stopPropagation() end)
	menu:addEventListener(Event.TOUCHES_MOVE, function(e) e:stopPropagation() end)
	menu:addEventListener(Event.TOUCHES_END, function(e) e:stopPropagation() end)
	
	--add buttons
	local resume = Bitmap.new(self.g:getTextureRegion("resume.png"))
	resume:setAnchorPoint(0.5, 0.5)
	local resumeButton = Button.new(resume)
	resumeButton:setPosition(conf.width/2, 100)
	resumeButton:addEventListener("click", self.closeMenu, self)
	menu:addChild(resumeButton)
	
	return menu
end

function LevelScene:openMenu()
	self.paused = true
	if not self.menu then
		self.menu = self:createMenu()
	end
	self:addChild(self.menu)
end

function LevelScene:closeMenu()
	self:removeChild(self.menu)
	self.paused = false
end

function LevelScene:onEnterFrame() 
	if not self.paused then
		-- update the world state
		self.world:step(1/60, 8, 3)
		--iterate through all child sprites
		local body
		for i = 1, #self.bodies do
			--get specific body
			body = self.bodies[i]
			--update object's position to match box2d world object's position
			--apply coordinates to sprite
			body.object:setPosition(body:getPosition())
			--apply rotation to sprite
			body.object:setRotation(math.deg(body:getAngle()))
		end
	end
end


function LevelScene:back()
	sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing) 
end

--define begin collision event handler function
function LevelScene:onBeginContact(e)
	--getting contact bodies
	local fixtureA = e.fixtureA
	local fixtureB = e.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	--check if this collision interests us
	if bodyA.type and bodyB.type then
		--check which bodies collide
		if bodyA.type == "touch" and bodyB.type == "main" then
			sounds:play("hit")
			--smile
			bodyB.object:smile()
			bodyA.object:hit()
			self:shakeScreen()
		end
	end
end

function LevelScene:onPostSolve(e)
	--getting contact bodies
	local fixtureA = e.fixtureA
	local fixtureB = e.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	--check if this collision interests us
	if bodyA.type and bodyB.type then
		--check which bodies collide
		if bodyA.type == "touch" and bodyB.type == "main" then
			bodyA.type = nil
			self:updateScore(math.floor(e.maxImpulse))
			self.ballsLeft = self.ballsLeft - 1
			if self.ballsLeft == 0 then
				self:completed()
			end
		end
	end
end

function LevelScene:shakeScreen()
	self:setPosition(-10, -10)
	GTween.new(self, 0.5, {x = 0,y = 0}, {delay = 0, ease = easing.outBounce })
end

function LevelScene:onMouseDown( event )
	if self.mainBall.body then
		if not self.paused then
			self.magnetStarted = true
			self.magnetX = event.x
			self.magnetY = event.y
		end
	end
end

function LevelScene:onMouseMove( event )
	if self.magnetStarted then
		self.magnetX = event.x
		self.magnetY = event.y
	end
end

function LevelScene:onMouseUp( event )
	if self.magnetStarted then
		self.magnetStarted = false
	end
end