levelScene = Core.class(Sprite)

function levelScene:init()
		
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
	
	--store all bodies sprites here
	self.bodies = {}
	print("creating ball")
	self.mainBall = MainBall.new(self, 100, 100)
	self:addChild(self.mainBall)
	
	
end

function levelScene:back()
	sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing) 
end