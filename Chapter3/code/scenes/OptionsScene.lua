OptionsScene = Core.class(Sprite)

function OptionsScene:init()
	local bg = Bitmap.new(Texture.new("images/bg.jpg", true))
	bg:setAnchorPoint(0.5, 0.5)
	bg:setPosition(conf.width/2, conf.height/2)
	self:addChild(bg)
	
	local optionsHeading = TextField.new(conf.fontMedium, "Options")
	optionsHeading:setPosition((conf.width - optionsHeading:getWidth())/2, 100)
	optionsHeading:setTextColor(0xffff00)
	self:addChild(optionsHeading)
	
	local usernameText = TextField.new(conf.fontSmall, "Your username is: "..sets:get("username"))
	usernameText:setPosition(100, 200)
	usernameText:setTextColor(0xffff00)
	self:addChild(usernameText)
	
	local changeText = TextField.new(conf.fontSmall, "Change it")
	changeText:setTextColor(0x00ff00)
	local changeButton = Button.new(changeText)
	changeButton:setPosition(conf.width - changeButton:getWidth() - 100, 200)
	self:addChild(changeButton)
	
	changeButton:addEventListener("click", function()
		local textInputDialog = TextInputDialog.new("Change Your Username", "Enter your new username", sets:get("username"), "Cancel", "Save")

		textInputDialog:addEventListener(Event.COMPLETE, function(event)
			if event.buttonIndex ~= nil then
				sets:set("username", event.text, true)
				usernameText:setText("Your username is: "..sets:get("username"))
			end
		end)
		textInputDialog:show()
	end)
	
	local backText = TextField.new(conf.fontMedium, "Back")
	backText:setTextColor(0xffff00)
	local backButton = Button.new(backText)
	backButton:setPosition((conf.width - backButton:getWidth())/2, conf.height - 50)
	self:addChild(backButton)
	backButton:addEventListener("click", function()
		sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing)
	end)
	
	self:addEventListener(Event.KEY_DOWN, function(event)
		if event.keyCode == KeyCode.BACK then
			sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing) 
		end
	end)
end