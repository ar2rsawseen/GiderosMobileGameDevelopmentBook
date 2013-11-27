local testbg = Bitmap.new(Texture.new("images/testbg.png", true))
testbg:setAnchorPoint(0.5, 0.5)
local halfWidth = application:getContentWidth()/2
local halfHeight = application:getContentHeight()/2
testbg:setPosition(halfWidth, halfHeight)
stage:addChild(testbg)

local dx = application:getLogicalTranslateX()/application:getLogicalScaleX()
local dy = application:getLogicalTranslateY()/application:getLogicalScaleY()
local ball = Bitmap.new(Texture.new("images/ball.png", true))
ball:setPosition(-dx,-dy)
stage:addChild(ball)

--get screen width
local width = application:getContentWidth()
local height = application:getContentHeight()

--top left
ball:setPosition(-dx, -dy)
 
--top right
ball:setPosition(dx+width-ball:getWidth(), -dy)
 
--bottom left
ball:setPosition(-dx, dy + height-ball:getHeight())
 
--bottom right
ball:setPosition(dx+width-ball:getWidth(), dy + height-ball:getHeight())