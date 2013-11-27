LevelSelectScene = Core.class(Sprite)

function LevelSelectScene:init()
	local bg = Bitmap.new(Texture.new("images/bg.jpg", true))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setPosition(conf.width/2, conf.height/2)
	self:addChild(bg)
	
	local backText = TextField.new(conf.fontMedium, "Back")
	backText:setTextColor(0xffff00)
	local backButton = Button.new(backText)
	backButton:setPosition((conf.width - backButton:getWidth())/2, conf.height - 30)
	self:addChild(backButton)
	backButton:addEventListener("click", function()
		sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing)
	end)
	
	self:addEventListener(Event.KEY_DOWN, function(event)
		if event.keyCode == KeyCode.BACK then
			sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing) 
		end
	end)
	
	self.curPack = sets:get("curPack")
	local packHeading = TextField.new(conf.fontMedium, packs[self.curPack].name)
	packHeading:setPosition((conf.width - packHeading:getWidth())/2, 50)
	packHeading:setTextColor(0xffff00)
	self:addChild(packHeading)
	
	if self.curPack == 1 and not gm:isUnlocked(1, 1) then
		gm:unlockLevel(1, 1)
	end
	
	local grid = Sprite.new()
	self:addChild(grid)
	
	local currentX, currentY = 0, 0 -- start coordinates
	local step = 100 -- increase per level
	local padding = 20 --padding between columns and rows
	local totalCol = 5 -- total count of columns
	local curCol = 0 --current column processing
	
	for i = 1, packs[self.curPack].levels do
		--create level image
		local level
		if gm:isUnlocked(self.curPack, i) then
			level = Bitmap.new(Texture.new("images/level_unlocked.png", true))
			level.id = i
			level.scene = self
			level:addEventListener(Event.MOUSE_UP, function(self, e)
				if self:hitTestPoint(e.x, e.y) then
					if not self.scene.startX or math.abs(self.scene.startX - e.x) <= 10 then
						sets:set("curLevel", self.id)
						sceneManager:changeScene("level", conf.transitionTime, conf.transition, conf.easing) 
					end
				end
			end, level)
		else
			level = Bitmap.new(Texture.new("images/level_locked.png", true))
		end
		level:setPosition(currentX, currentY)
		grid:addChild(level)
		
		--add level number
		local levelNumber = TextField.new(conf.fontMedium, i)
		levelNumber:setTextColor(0xffffff)
		levelNumber:setPosition(10, 40)
		level:addChild(levelNumber)
		
		--manipulate level position in the grid
		curCol = curCol + 1
		if curCol == totalCol then
			curCol = 0
			currentX = 0
			currentY = currentY + padding + step
		else
			currentX = currentX + padding + step
		end
	end
	
	grid:setPosition((conf.width - grid:getWidth())/2, 70)
	
	if self.curPack < #packs then
		local right = Bitmap.new(Texture.new("images/right.png", true))
		local rightButton = Button.new(right)
		rightButton:setPosition(conf.dx + conf.width - rightButton:getWidth(), 
			conf.dy + conf.height - rightButton:getHeight())
		self:addChild(rightButton)
		rightButton:addEventListener("click", self.nextPack, self)
	end
	
	if self.curPack > 1 then
		local left = Bitmap.new(Texture.new("images/left.png", true))
		local leftButton = Button.new(left)
		leftButton:setPosition(-conf.dx, conf.dy + conf.height - leftButton:getHeight())
		self:addChild(leftButton)
		leftButton:addEventListener("click", self.prevPack, self)
	end
	self:addEventListener("enterEnd", self.onEnterEnd, self)
end

function LevelSelectScene:nextPack()
	if self.curPack < #packs then
		sets:set("curPack", self.curPack + 1)
		sceneManager:changeScene("levelselect", conf.transitionTime, SceneManager.moveFromRight, conf.easing) 
	end
end

function LevelSelectScene:prevPack()
	if self.curPack > 1 then
		sets:set("curPack", self.curPack - 1)
		sceneManager:changeScene("levelselect", conf.transitionTime, SceneManager.moveFromLeft, conf.easing) 
	end
end

function LevelSelectScene:onMouseDown(event)
	self.isFocus = true
	self.startX = event.x
	self.initX = self:getX()
	self.prevX = event.x
	event:stopPropagation()
end

function LevelSelectScene:onMouseMove(event)
	if self.isFocus then
		local dx = event.x - self.prevX
		self:setX(self:getX() + dx)
		self.prevX = event.x	
		event:stopPropagation()
	end
end

function LevelSelectScene:onMouseUp(event)
	if self.isFocus then
		local back = false
		if self.startX < self.prevX - 10 then
			if self.curPack > 1 then
				self:prevPack()
			else
				back = true
			end
		elseif self.startX > self.prevX + 10 then
			if self.curPack <= #packs then
				self:nextPack()
			else
				back = true
			end
		else
			back = true
		end
		if back then
			GTween.new(self, 0.1, {x = self.initX})
		end
		self.isFocus = false
		event:stopPropagation()
	end
end

function LevelSelectScene:onEnterEnd()
	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)
end