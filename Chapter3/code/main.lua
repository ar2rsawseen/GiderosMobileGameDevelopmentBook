require "box2d"
sets = Settings.new()
gm = GameManager.new()

--define scenes
sceneManager = SceneManager.new({
	--start scene
	["start"] = StartScene,
	--about scene
	["about"] = AboutScene,
	--options scene
	["options"] = OptionsScene,
	--level scene
	["level"] = LevelScene,
	--level select scene
	["levelselect"] = LevelSelectScene,
})
--add manager to stage
stage:addChild(sceneManager)

--go to start scene
sceneManager:changeScene("start", conf.transitionTime, conf.transition, conf.easing)
