conf = {
	transition = SceneManager.fade,
	transitionTime = 1,
	easing = easing.outBack,
	textureFilter = true,
	width = application:getContentWidth(),
	height = application:getContentHeight(),
	dx = application:getLogicalTranslateX() / application:getLogicalScaleX(),
	dy = application:getLogicalTranslateY() / application:getLogicalScaleY(),
	fontLarge = TTFont.new("fonts/deftone stylus.ttf", 70, true),
	fontMedium = TTFont.new("fonts/deftone stylus.ttf", 50, true),
	fontSmall = TTFont.new("fonts/deftone stylus.ttf", 30, true),
}